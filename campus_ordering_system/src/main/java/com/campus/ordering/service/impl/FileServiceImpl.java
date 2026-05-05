package com.campus.ordering.service.impl;

import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.IdUtil;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.service.FileService;
import com.campus.ordering.service.OssService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@Service
public class FileServiceImpl implements FileService {

    @Autowired(required = false)
    private OssService ossService;

    @Value("${system.file.upload-path}")
    private String uploadPath;

    @Value("${system.file.access-url}")
    private String accessUrl;

    @Override
    public String uploadImage(MultipartFile file) {
        if (ossService != null) {
            try {
                return ossService.uploadFile(file, "images");
            } catch (Exception e) {
                // OSS上传失败，使用本地文件上传作为备用
                return uploadLocalFile(file, "images");
            }
        } else {
            // 没有配置OSS，使用本地文件上传
            return uploadLocalFile(file, "images");
        }
    }

    private String uploadLocalFile(MultipartFile file, String directory) {
        if (file == null || file.isEmpty()) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "上传文件不能为空");
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || !originalFilename.matches(".*\\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF|webp|WEBP)$")) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "只支持图片格式文件（jpg、jpeg、png、gif、webp）");
        }

        try {
            String suffix = originalFilename.substring(originalFilename.lastIndexOf("."));
            String fileName = IdUtil.fastSimpleUUID() + suffix;

            String dateDir = new SimpleDateFormat("yyyyMMdd").format(new Date());
            // 使用系统默认的文件分隔符
            String filePath = uploadPath + File.separator + directory + File.separator + dateDir;

            // 创建目录
            FileUtil.mkdir(filePath);

            // 保存文件
            File destFile = new File(filePath + File.separator + fileName);
            file.transferTo(destFile);

            // 构建访问URL（URL中使用/作为分隔符）
            String fileUrl = accessUrl + "/" + directory + "/" + dateDir + "/" + fileName;
            return fileUrl;
        } catch (IOException e) {
            throw new BusinessException(ResultCode.ERROR, "文件上传失败：" + e.getMessage());
        }
    }
}
