package com.example.smartsurveysystem.dto;

import com.fasterxml.jackson.annotation.JsonCreator;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class JumpRuleDTO {
    private Long optionId; // 触发跳转的选项ID
    private Long targetQuestionId; // 跳转目标问题ID

    @JsonCreator
    public JumpRuleDTO(Map<String, Object> map) {
        this.optionId = Long.parseLong(map.get("optionId").toString());
        this.targetQuestionId = Long.parseLong(map.get("targetQuestionId").toString());
    }
}
