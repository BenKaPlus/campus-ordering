package com.campus.ordering.service;

import com.campus.ordering.dto.StudentInfoUpdateDTO;
import com.campus.ordering.entity.StudentInfo;

public interface StudentInfoService {

    StudentInfo getStudentInfo(Long userId);

    void updateStudentInfo(Long userId, StudentInfoUpdateDTO dto);
}
