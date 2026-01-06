package com.example.smartsurveysystem.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

/**
 * 问题实体类：映射到数据库中的 question 表
 */
@Entity
@Table(name = "question")
@Data
@NoArgsConstructor
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // 主键

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "questionnaire_id", nullable = false)
    @JsonIgnore // 避免JSON序列化时的循环引用
    private Questionnaire questionnaire; // 所属问卷的外键

    @Column(nullable = false)
    private String content; // 问题内容

    // 类型：1=单选, 2=多选, 3=文本
    @Column(nullable = false)
    private Integer type;

    private Integer questionOrder; // 问题在问卷中的顺序

    // 问题与选项：一对多关系 (适用于单选和多选)
    @OneToMany(mappedBy = "question", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Option> options;
}