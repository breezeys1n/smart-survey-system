package com.example.smartsurveysystem.repository; // 确保包名正确

import com.example.smartsurveysystem.entity.Questionnaire;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

// 继承 JpaRepository<实体类, 主键类型>
public interface QuestionnaireRepository extends JpaRepository<Questionnaire, Long> {
    // 自动获得 save(), findById(), findAll(), delete() 等基本方法
    List<Questionnaire> findAllByOrderByCreateTimeDesc();
    List<Questionnaire> findByStatus(Integer status);
}