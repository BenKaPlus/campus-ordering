package com.campus.ordering.service;

import org.springframework.web.multipart.MultipartFile;

public interface OssService {

    String uploadFile(MultipartFile file, String directory);

    String uploadFile(byte[] data, String fileName, String directory);

    void deleteFile(String fileUrl);

    String getFileUrl(String objectName);
}
