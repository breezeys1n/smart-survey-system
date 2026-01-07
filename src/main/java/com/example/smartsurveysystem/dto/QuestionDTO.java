package com.example.smartsurveysystem.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QuestionDTO {
    private String content;
    private Integer type; // 1=单选, 2=多选, 3=文本
    private Integer order;
    private List<OptionDTO> options;
    private List<JumpRuleDTO> jumpRules;
}
