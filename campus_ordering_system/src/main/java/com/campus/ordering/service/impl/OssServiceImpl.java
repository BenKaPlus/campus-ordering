package com.campus.ordering.service.impl;

import cn.hutool.core.util.IdUtil;
import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.aliyun.oss.common.auth.DefaultCredentialProvider;
import com.aliyun.oss.common.auth.CredentialsProvider;
import com.aliyun.oss.common.comm.SignVersion;
import com.aliyun.oss.model.ObjectMetadata;
import com.aliyun.oss.model.PutObjectRequest;
import com.campus.ordering.common.ResultCode;
import com.campus.ordering.config.OssConfig;
import com.campus.ordering.exception.BusinessException;
import com.campus.ordering.service.OssService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

@Slf4j
@Service
public class OssServiceImpl implements OssService {

    @Autowired
    private OssConfig ossConfig;

    private OSS ossClient;

    @PostConstruct
    public void init() {
        CredentialsProvider credentialsProvider = new DefaultCredentialProvider(
                ossConfig.getAccessKeyId(), ossConfig.getAccessKeySecret());

        ossClient = OSSClientBuilder.create()
                .endpoint(ossConfig.getEndpoint())
                .credentialsProvider(credentialsProvider)
                .build();

        log.info("阿里云OSS客户端初始化成功，bucket: {}", ossConfig.getBucketName());
    }

    @PreDestroy
    public void destroy() {
        if (ossClient != null) {
            ossClient.shutdown();
            log.info("阿里云OSS客户端已关闭");
        }
    }

    @Override
    public String uploadFile(MultipartFile file, String directory) {
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
            String objectName = directory + "/" + dateDir + "/" + fileName;

            InputStream inputStream = file.getInputStream();
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(file.getSize());
            metadata.setContentType(file.getContentType());

            PutObjectRequest putObjectRequest = new PutObjectRequest(
                    ossConfig.getBucketName(), objectName, inputStream, metadata);
            ossClient.putObject(putObjectRequest);

            String fileUrl = ossConfig.getBaseUrl() + "/" + objectName;
            log.info("文件上传成功: {}", fileUrl);
            return fileUrl;
        } catch (IOException e) {
            log.error("文件上传失败: {}", e.getMessage(), e);
            throw new BusinessException(ResultCode.ERROR, "文件上传失败：" + e.getMessage());
        }
    }

    @Override
    public String uploadFile(byte[] data, String fileName, String directory) {
        if (data == null || data.length == 0) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "上传数据不能为空");
        }

        String dateDir = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String objectName = directory + "/" + dateDir + "/" + fileName;

        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(data.length);

        String contentType = getContentType(fileName);
        metadata.setContentType(contentType);

        ByteArrayInputStream inputStream = new ByteArrayInputStream(data);
        PutObjectRequest putObjectRequest = new PutObjectRequest(
                ossConfig.getBucketName(), objectName, inputStream, metadata);
        ossClient.putObject(putObjectRequest);

        String fileUrl = ossConfig.getBaseUrl() + "/" + objectName;
        log.info("文件上传成功: {}", fileUrl);
        return fileUrl;
    }

    @Override
    public void deleteFile(String fileUrl) {
        if (fileUrl == null || fileUrl.isEmpty()) {
            return;
        }

        String objectName = extractObjectName(fileUrl);
        if (objectName != null) {
            ossClient.deleteObject(ossConfig.getBucketName(), objectName);
            log.info("文件删除成功: {}", objectName);
        }
    }

    @Override
    public String getFileUrl(String objectName) {
        return ossConfig.getBaseUrl() + "/" + objectName;
    }

    private String extractObjectName(String fileUrl) {
        if (fileUrl == null || !fileUrl.startsWith(ossConfig.getBaseUrl())) {
            return null;
        }
        return fileUrl.substring(ossConfig.getBaseUrl().length() + 1);
    }

    private String getContentType(String fileName) {
        String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        switch (extension) {
            case "jpg":
            case "jpeg":
                return "image/jpeg";
            case "png":
                return "image/png";
            case "gif":
                return "image/gif";
            case "webp":
                return "image/webp";
            default:
                return "application/octet-stream";
        }
    }
}
