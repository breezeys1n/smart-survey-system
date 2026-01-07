package com.example.smartsurveysystem.service;

import com.example.smartsurveysystem.dto.QuestionnaireDTO;
import com.example.smartsurveysystem.entity.Questionnaire;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/manage/questionnaires")
public class QuestionnaireManageController {

    private final QuestionnaireService questionnaireService;

    public QuestionnaireManageController(QuestionnaireService questionnaireService) {
        this.questionnaireService = questionnaireService;
    }

    /**
     * 创建问卷
     */
    @PostMapping
    public ResponseEntity<Questionnaire> createQuestionnaire(@RequestBody QuestionnaireDTO dto) {
        Questionnaire questionnaire = questionnaireService.createQuestionnaire(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(questionnaire);
    }

    /**
     * 更新问卷
     */
    @PutMapping("/{id}")
    public ResponseEntity<Questionnaire> updateQuestionnaire(
            @PathVariable Long id,
            @RequestBody QuestionnaireDTO dto) {
        Questionnaire questionnaire = questionnaireService.updateQuestionnaire(id, dto);
        return ResponseEntity.ok(questionnaire);
    }

    /**
     * 删除问卷
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteQuestionnaire(@PathVariable Long id) {
        questionnaireService.deleteQuestionnaire(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * 获取问卷详情
     */
    @GetMapping("/{id}")
    public ResponseEntity<Questionnaire> getQuestionnaire(@PathVariable Long id) {
        Questionnaire questionnaire = questionnaireService.getQuestionnaireById(id);
        return ResponseEntity.ok(questionnaire);
    }

    /**
     * 获取所有问卷列表
     */
    @GetMapping
    public ResponseEntity<List<Questionnaire>> getAllQuestionnaires() {
        List<Questionnaire> questionnaires = questionnaireService.getAllQuestionnaires();
        return ResponseEntity.ok(questionnaires);
    }

    /**
     * 发布问卷
     */
    @PostMapping("/{id}/publish")
    public ResponseEntity<Questionnaire> publishQuestionnaire(@PathVariable Long id) {
        Questionnaire questionnaire = questionnaireService.publishQuestionnaire(id);
        return ResponseEntity.ok(questionnaire);
    }

    /**
     * 获取完整问卷（包含问题、选项、跳转逻辑）
     */
    @GetMapping("/{id}/full")
    public ResponseEntity<Questionnaire> getFullQuestionnaire(@PathVariable Long id) {
        Questionnaire questionnaire = questionnaireService.getFullQuestionnaire(id);
        return ResponseEntity.ok(questionnaire);
    }
}
