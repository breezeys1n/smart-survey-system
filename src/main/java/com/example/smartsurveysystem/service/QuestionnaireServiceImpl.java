package com.example.smartsurveysystem.service;

import com.example.smartsurveysystem.repository.OptionRepository;
import com.example.smartsurveysystem.dto.JumpRuleDTO;
import com.example.smartsurveysystem.dto.OptionDTO;
import com.example.smartsurveysystem.dto.QuestionDTO;
import com.example.smartsurveysystem.dto.QuestionnaireDTO;
import com.example.smartsurveysystem.entity.*;
import com.example.smartsurveysystem.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tools.jackson.core.type.TypeReference;
import tools.jackson.databind.ObjectMapper;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class QuestionnaireServiceImpl implements QuestionnaireService {

    private final QuestionnaireRepository questionnaireRepository;
    private final UserResponseRepository userResponseRepository;
    private final AnswerDetailRepository answerDetailRepository;
    private final QuestionRepository questionRepository;
    private final OptionRepository optionRepository;
    public QuestionnaireServiceImpl(QuestionnaireRepository questionnaireRepository,
                                    UserResponseRepository userResponseRepository,
                                    AnswerDetailRepository answerDetailRepository,
                                    QuestionRepository questionRepository,
                                    OptionRepository optionRepository) {
        this.questionnaireRepository = questionnaireRepository;
        this.userResponseRepository = userResponseRepository;
        this.answerDetailRepository = answerDetailRepository;
        this.questionRepository = questionRepository;
        this.optionRepository=optionRepository;
    }
    @Override
    public Questionnaire createQuestionnaire(QuestionnaireDTO dto) {
        Questionnaire questionnaire = new Questionnaire();
        questionnaire.setTitle(dto.getTitle());
        questionnaire.setDescription(dto.getDescription());
        questionnaire.setCreateTime(LocalDateTime.now());
        questionnaire.setStatus(0); // 草稿状态

        Questionnaire savedQuestionnaire = questionnaireRepository.save(questionnaire);

        // 保存问题
        if (dto.getQuestions() != null && !dto.getQuestions().isEmpty()) {
            for (int i = 0; i < dto.getQuestions().size(); i++) {
                QuestionDTO questionDTO = dto.getQuestions().get(i);
                saveQuestion(savedQuestionnaire, questionDTO, i + 1);
            }
        }

        return questionnaireRepository.findById(savedQuestionnaire.getId())
                .orElseThrow(() -> new RuntimeException("问卷创建失败"));
    }

    private void saveQuestion(Questionnaire questionnaire, QuestionDTO dto, int order) {
        Question question = new Question();
        question.setQuestionnaire(questionnaire);
        question.setContent(dto.getContent());
        question.setType(dto.getType());
        question.setQuestionOrder(order);

        // 保存跳转逻辑
        if (dto.getJumpRules() != null && !dto.getJumpRules().isEmpty()) {

            ObjectMapper mapper = new ObjectMapper();
            String jumpLogic = mapper.writeValueAsString(dto.getJumpRules());
            question.setJumpLogic(jumpLogic);

        }

        Question savedQuestion = questionRepository.save(question);

        // 保存选项
        if (dto.getOptions() != null && !dto.getOptions().isEmpty()) {
            for (int i = 0; i < dto.getOptions().size(); i++) {
                OptionDTO optionDTO = dto.getOptions().get(i);
                saveOption(savedQuestion, optionDTO, i + 1);
            }
        }
    }

    private void saveOption(Question question, OptionDTO dto, int order) {
        Option option = new Option();
        option.setQuestion(question);
        option.setOptionText(dto.getOptionText());
        option.setOptionOrder(order);
        optionRepository.save(option);
    }

    @Override
    public Questionnaire updateQuestionnaire(Long id, QuestionnaireDTO dto) {
        Questionnaire questionnaire = questionnaireRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("问卷不存在"));

        // 只有草稿状态的问卷可以修改
        if (!questionnaire.getStatus().equals(0)) {
            throw new RuntimeException("已发布的问卷不能修改");
        }

        questionnaire.setTitle(dto.getTitle());
        questionnaire.setDescription(dto.getDescription());

        // 获取当前问卷的所有问题
        List<Question> existingQuestions = questionnaire.getQuestions();
        if (existingQuestions != null) {
            // 清除问题列表（这会级联删除关联的选项，因为设置了 cascade = CascadeType.ALL）
            existingQuestions.clear();
            questionnaireRepository.save(questionnaire);
        }

        questionnaire.setTitle(dto.getTitle());
        questionnaire.setDescription(dto.getDescription());

        // 保存新的问题
        if (dto.getQuestions() != null && !dto.getQuestions().isEmpty()) {
            for (int i = 0; i < dto.getQuestions().size(); i++) {
                QuestionDTO questionDTO = dto.getQuestions().get(i);
                saveQuestion(questionnaire, questionDTO, i + 1);
            }
        }

        return questionnaireRepository.save(questionnaire);
    }

    @Override
    public void deleteQuestionnaire(Long id) {
        Questionnaire questionnaire = questionnaireRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("问卷不存在"));

        // 检查是否有回答记录
        long responseCount = userResponseRepository.countByQuestionnaireId(id);
        if (responseCount > 0) {
            throw new RuntimeException("该问卷已有回答记录，不能删除");
        }

        // 级联删除问题、选项和答案
        questionnaireRepository.delete(questionnaire);
    }

    @Override
    public Questionnaire getQuestionnaireById(Long id) {
        return questionnaireRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("问卷不存在"));
    }

    @Override
    public List<Questionnaire> getAllQuestionnaires() {
        return questionnaireRepository.findAllByOrderByCreateTimeDesc();
    }

    @Override
    public Questionnaire publishQuestionnaire(Long id) {
        Questionnaire questionnaire = questionnaireRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("问卷不存在"));

        // 检查问卷是否有问题
        List<Question> questions = questionRepository.findAllByQuestionnaireId(id);
        if (questions == null || questions.isEmpty()) {
            throw new RuntimeException("问卷没有问题，不能发布");
        }

        questionnaire.setStatus(1); // 发布状态
        questionnaireRepository.save(questionnaire);

        // 验证逻辑跳转规则
        validateJumpLogic(questions);

        return questionnaire;
    }

    private void validateJumpLogic(List<Question> questions) {
        Map<Long, Question> questionMap = questions.stream()
                .collect(Collectors.toMap(Question::getId, q -> q));

        for (Question question : questions) {
            if (question.getJumpLogic() != null && !question.getJumpLogic().isEmpty()) {
                try {
                    ObjectMapper mapper = new ObjectMapper();
                    List<JumpRuleDTO> rules = mapper.readValue(
                            question.getJumpLogic(),
                            new TypeReference<List<JumpRuleDTO>>() {}
                    );

                    for (JumpRuleDTO rule : rules) {
                        if (!questionMap.containsKey(rule.getTargetQuestionId())) {
                            throw new RuntimeException(
                                    String.format("问题%d的跳转目标问题%d不存在",
                                            question.getId(), rule.getTargetQuestionId())
                            );
                        }
                    }
                } catch (Exception e) {
                    throw new RuntimeException("跳转逻辑验证失败: " + e.getMessage());
                }
            }
        }
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