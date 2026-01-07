package com.example.smartsurveysystem.repository;

import com.example.smartsurveysystem.entity.UserResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface UserResponseRepository extends JpaRepository<UserResponse, Long> {
    // 查找某个问卷的所有用户回复记录 (用于统计分析)
    List<UserResponse> findAllByQuestionnaireId(Long questionnaireId);
    long countByQuestionnaireId(Long questionnaireId);
}