package com.example.smartsurveysystem.controller;

import com.example.smartsurveysystem.service.StatisticsService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
@RequestMapping("/api/v1/statistics")
public class StatisticsController {

    private final StatisticsService statisticsService;

    public StatisticsController(StatisticsService statisticsService) {
        this.statisticsService = statisticsService;
    }

    @GetMapping("/question/{questionId}")
    public ResponseEntity<Map<String, Object>> getQuestionStats(@PathVariable Long questionId) {
        Map<String, Object> stats = statisticsService.getQuestionStatistics(questionId);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/questionnaire/{id}/full-analysis")
    public ResponseEntity<Map<String, Object>> getFullAnalysis(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();

        // 现在 Service 接口和实现类里都有这个方法了，不再报错
        response.put("summary", statisticsService.getQuestionnaireStatistics(id));
        response.put("questionsAnalysis", statisticsService.getFullQuestionnaireAnalysis(id));

        return ResponseEntity.ok(response);
    }
}