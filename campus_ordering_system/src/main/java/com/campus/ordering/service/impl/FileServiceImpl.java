package com.campus.ordering.service.impl;

import cn.hutool.core.util.IdUtil;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.service.FileService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;

@Service
public class FileServiceImpl implements FileService {

    @Value("${system.file.upload-path:./upload}")
    private String uploadPath;

    @Value("${system.file.access-url:http://localhost:8080/api/file}")
    private String accessUrl;

    @PostConstruct
    public void init() {
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }

    @Override
    public String uploadImage(MultipartFile file) {
        if (file.isEmpty()) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "上传文件不能为空");
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || !originalFilename.matches(".*\\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF)$")) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "只支持图片格式文件（jpg、jpeg、png、gif）");
        }

        try {
            String suffix = originalFilename.substring(originalFilename.lastIndexOf("."));
            String fileName = IdUtil.fastSimpleUUID() + suffix;
            
            String dateDir = new SimpleDateFormat("yyyyMMdd").format(new Date());
            Path datePath = Paths.get(uploadPath, dateDir);
            if (!Files.exists(datePath)) {
                Files.createDirectories(datePath);
            }

            Path filePath = datePath.resolve(fileName);
            file.transferTo(filePath.toFile());

            return accessUrl + "/" + dateDir + "/" + fileName;
        } catch (IOException e) {
            throw new BusinessException(ResultCode.ERROR, "文件上传失败：" + e.getMessage());
        }
    }
}
