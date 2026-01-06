package com.example.smartsurveysystem.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 用户作答记录实体类：记录一次完整的问卷填写
 */
@Entity
@Table(name = "user_response")
@Data
@NoArgsConstructor
public class UserResponse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // 主键

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "questionnaire_id", nullable = false)
    @JsonIgnore // 避免JSON序列化时的循环引用
    private Questionnaire questionnaire; // 所属问卷的外键

    @Column(nullable = false)
    private LocalDateTime submitTime; // 提交时间

    @Column(length = 50)
    private String responderIp; // 答题者IP (用于限制重复提交)

    // 一次回复与多个回答详情：一对多关系
    @OneToMany(mappedBy = "userResponse", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<AnswerDetail> answerDetails;
}