package com.example.smartsurveysystem.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 回答详情实体类：记录用户对单个问题的回答
 */
@Entity
@Table(name = "answer_detail")
@Data
@NoArgsConstructor
public class AnswerDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // 主键

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "response_id", nullable = false)
    @JsonIgnore // 避免JSON序列化时的循环引用
    private UserResponse userResponse; // 所属回复的外键

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    @JsonIgnore // 避免JSON序列化时的循环引用
    private Question question; // 回答的问题外键

    // 对于文本题：存储用户输入的文本
    @Lob
    private String textAnswer;

    // 对于选择题：存储用户选择的选项ID (多选时可存储为逗号分隔的字符串，或使用单独的关联表)
    // 简化处理：对于选择题，可以直接存储选中的选项ID（单选）或多个选项ID（多选）
    @Column(length = 500)
    private String selectedOptionIds;
}