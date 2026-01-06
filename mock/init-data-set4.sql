-- 测试数据集4: 纯文本问卷（文本题测试）
USE smart_survey;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE answer_detail;
TRUNCATE TABLE user_response;
TRUNCATE TABLE option_item;
TRUNCATE TABLE question;
TRUNCATE TABLE questionnaire;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO questionnaire (id, title, description, create_time, status) 
VALUES (1, '开放式反馈问卷', '请自由表达您的想法和建议', NOW(), 1);

INSERT INTO question (id, content, type, question_order, questionnaire_id) VALUES 
(1, '请描述您使用产品的体验', 3, 1, 1),
(2, '您认为产品最大的优点是什么？', 3, 2, 1),
(3, '您希望产品增加什么功能？', 3, 3, 1);

INSERT INTO user_response (id, responder_ip, submit_time, questionnaire_id) VALUES 
(1, '192.168.1.40', NOW(), 1),
(2, '192.168.1.41', NOW(), 1),
(3, '192.168.1.42', NOW(), 1);

INSERT INTO answer_detail (selected_option_ids, text_answer, question_id, response_id) VALUES 
(NULL, '产品使用起来很方便，界面简洁明了，功能也很实用。', 1, 1),
(NULL, '最大的优点是操作简单，不需要太多学习成本。', 2, 1),
(NULL, '希望能增加数据导出功能，方便后续分析。', 3, 1),
(NULL, '整体体验不错，但有时候响应速度有点慢。', 1, 2),
(NULL, '功能比较全面，能满足日常使用需求。', 2, 2),
(NULL, '建议增加批量操作功能，提高工作效率。', 3, 2),
(NULL, '产品设计很人性化，用户体验很好。', 1, 3),
(NULL, '界面美观，交互流畅。', 2, 3),
(NULL, '希望增加更多个性化设置选项。', 3, 3);

