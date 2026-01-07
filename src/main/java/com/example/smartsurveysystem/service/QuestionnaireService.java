package com.example.smartsurveysystem.service;

import com.example.smartsurveysystem.dto.QuestionnaireDTO;
import com.example.smartsurveysystem.entity.Questionnaire;

import java.util.List;
import java.util.Map;

public interface QuestionnaireService {
    Questionnaire createQuestionnaire(QuestionnaireDTO dto);
    Questionnaire updateQuestionnaire(Long id, QuestionnaireDTO dto);
    void deleteQuestionnaire(Long id);
    Questionnaire getQuestionnaireById(Long id);
    List<Questionnaire> getAllQuestionnaires();
    Questionnaire publishQuestionnaire(Long id);
    // 获取完整的问卷结构（含题目和选项），供用户填写
    Questionnaire getFullQuestionnaire(Long id);

    // 保存用户的提交数据
    void saveResponse(Long questionnaireId, Map<String, Object> submissionData, String ip);
}