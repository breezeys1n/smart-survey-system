package com.example.smartsurveysystem.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 问卷实体类：映射到数据库中的 questionnaire 表
 */
@Entity
@Table(name = "questionnaire")
@Data
@NoArgsConstructor
public class Questionnaire {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // 主键

    @Column(nullable = false, length = 255)
    private String title; // 问卷标题

    @Lob // 用于存储长文本，对应数据库的 TEXT/LONGTEXT
    private String description; // 问卷描述

    @Column(nullable = false)
    private LocalDateTime createTime; // 创建时间

    // 状态：0=草稿, 1=发布中, 2=已结束
    private Integer status = 0;

    // 问卷与问题：一对多关系 (FetchType.LAZY 避免不必要的加载)
    @OneToMany(mappedBy = "questionnaire", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Question> questions;

    // 问卷与回复：一对多关系
    @OneToMany(mappedBy = "questionnaire", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonIgnore // 避免JSON序列化时的循环引用，前端不需要responses数据
    private List<UserResponse> responses;
}