package com.campus.ordering.service;

import org.springframework.web.multipart.MultipartFile;

public interface FileService {
    /**
     * 上传图片
     */
    String uploadImage(MultipartFile file);
}
