package com.campus.ordering.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.campus.ordering.dto.StudentInfoUpdateDTO;
import com.campus.ordering.entity.StudentInfo;
import com.campus.ordering.entity.SysUser;
import com.campus.ordering.mapper.StudentInfoMapper;
import com.campus.ordering.mapper.SysUserMapper;
import com.campus.ordering.service.StudentInfoService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

@Service
public class StudentInfoServiceImpl implements StudentInfoService {

    @Resource
    private StudentInfoMapper studentInfoMapper;

    @Resource
    private SysUserMapper sysUserMapper;

    @Override
    public StudentInfo getStudentInfo(Long userId) {
        LambdaQueryWrapper<StudentInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StudentInfo::getUserId, userId);
        StudentInfo studentInfo = studentInfoMapper.selectOne(wrapper);

        if (studentInfo != null) {
            SysUser sysUser = sysUserMapper.selectById(userId);
            if (sysUser != null) {
                studentInfo.setUserName(sysUser.getUserName());
                studentInfo.setPhone(sysUser.getPhone());
                studentInfo.setUserNo(sysUser.getUserNo());
            }
        }

        return studentInfo;
    }

    @Override
    @Transactional
    public void updateStudentInfo(Long userId, StudentInfoUpdateDTO dto) {
        LambdaQueryWrapper<StudentInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StudentInfo::getUserId, userId);
        StudentInfo studentInfo = studentInfoMapper.selectOne(wrapper);

        if (studentInfo == null) {
            studentInfo = new StudentInfo();
            studentInfo.setUserId(userId);
            if (dto.getStudentNo() != null) {
                studentInfo.setStudentNo(dto.getStudentNo());
            }
            if (dto.getCollege() != null) {
                studentInfo.setCollege(dto.getCollege());
            }
            if (dto.getMajor() != null) {
                studentInfo.setMajor(dto.getMajor());
            }
            if (dto.getGrade() != null) {
                studentInfo.setGrade(dto.getGrade());
            }
            if (dto.getDormitory() != null) {
                studentInfo.setDormitory(dto.getDormitory());
            }
            studentInfoMapper.insert(studentInfo);
        } else {
            if (dto.getCollege() != null) {
                studentInfo.setCollege(dto.getCollege());
            }
            if (dto.getMajor() != null) {
                studentInfo.setMajor(dto.getMajor());
            }
            if (dto.getGrade() != null) {
                studentInfo.setGrade(dto.getGrade());
            }
            if (dto.getDormitory() != null) {
                studentInfo.setDormitory(dto.getDormitory());
            }
            studentInfoMapper.updateById(studentInfo);
        }

        SysUser sysUser = sysUserMapper.selectById(userId);
        if (sysUser != null) {
            if (dto.getUserName() != null) {
                sysUser.setUserName(dto.getUserName());
            }
            if (dto.getPhone() != null) {
                sysUser.setPhone(dto.getPhone());
            }
            sysUserMapper.updateById(sysUser);
        }
    }
}
