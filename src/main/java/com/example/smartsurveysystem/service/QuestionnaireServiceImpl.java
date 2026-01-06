package com.example.smartsurveysystem.service;

import com.example.smartsurveysystem.entity.*;
import com.example.smartsurveysystem.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Service
public class QuestionnaireServiceImpl implements QuestionnaireService {

    private final QuestionnaireRepository questionnaireRepository;
    private final UserResponseRepository userResponseRepository;
    private final AnswerDetailRepository answerDetailRepository;
    private final QuestionRepository questionRepository;

    public QuestionnaireServiceImpl(QuestionnaireRepository questionnaireRepository,
                                    UserResponseRepository userResponseRepository,
                                    AnswerDetailRepository answerDetailRepository,
                                    QuestionRepository questionRepository) {
        this.questionnaireRepository = questionnaireRepository;
        this.userResponseRepository = userResponseRepository;
        this.answerDetailRepository = answerDetailRepository;
        this.questionRepository = questionRepository;
    }

    @Override
    @Transactional(readOnly = true) // 开启只读事务，确保懒加载关联数据
    public Questionnaire getFullQuestionnaire(Long id) {
        // 查找问卷
        Questionnaire questionnaire = questionnaireRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("问卷不存在"));
        
        // 手动触发懒加载：访问questions集合以触发加载
        if (questionnaire.getQuestions() != null) {
            questionnaire.getQuestions().size(); // 触发questions的加载
            
            // 触发每个问题的options加载
            for (Question question : questionnaire.getQuestions()) {
                if (question.getOptions() != null) {
                    question.getOptions().size(); // 触发options的加载
                }
            }
        }
        
        return questionnaire;
    }

    @Override
    @Transactional // 开启事务，确保回答和详情要么全部成功，要么全部失败
    public void saveResponse(Long questionnaireId, Map<String, Object> submissionData, String ip) {
        Questionnaire questionnaire = questionnaireRepository.findById(questionnaireId)
                .orElseThrow(() -> new RuntimeException("问卷不存在"));

        // 1. 保存总的提交记录
        UserResponse response = new UserResponse();
        response.setQuestionnaire(questionnaire);
        response.setSubmitTime(LocalDateTime.now());
        response.setResponderIp(ip);
        UserResponse savedResponse = userResponseRepository.save(response);

        // 2. 遍历提交的答案数据并保存详情
        // 假设 submissionData 格式为 { "questionId": "answerValue" }
        submissionData.forEach((qIdStr, value) -> {
            Long qId = Long.parseLong(qIdStr);
            Question question = questionRepository.findById(qId).orElse(null);

            if (question != null) {
                AnswerDetail detail = new AnswerDetail();
                detail.setUserResponse(savedResponse);
                detail.setQuestion(question);

                if (question.getType() == 3) { // 文本题
                    detail.setTextAnswer(value.toString());
                } else { // 选择题 (单选或多选)
                    // 如果是多选，前端通常传 "101,102" 格式的字符串
                    detail.setSelectedOptionIds(value.toString());
                }
                answerDetailRepository.save(detail);
            }
        });
    }
}