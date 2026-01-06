-- 测试数据集3: 简单单题问卷（最小测试）
USE smart_survey;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE answer_detail;
TRUNCATE TABLE user_response;
TRUNCATE TABLE option_item;
TRUNCATE TABLE question;
TRUNCATE TABLE questionnaire;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO questionnaire (id, title, description, create_time, status) 
VALUES (1, '快速反馈问卷', '请简单回答一个问题', NOW(), 1);

INSERT INTO question (id, content, type, question_order, questionnaire_id) VALUES 
(1, '您对我们的服务是否满意？', 1, 1, 1);

INSERT INTO option_item (id, option_text, option_order, question_id) VALUES 
(101, '非常满意', 1, 1),
(102, '满意', 2, 1),
(103, '一般', 3, 1),
(104, '不满意', 4, 1);

INSERT INTO user_response (id, responder_ip, submit_time, questionnaire_id) VALUES 
(1, '192.168.1.30', NOW(), 1),
(2, '192.168.1.31', NOW(), 1);

INSERT INTO answer_detail (selected_option_ids, text_answer, question_id, response_id) VALUES 
('101', NULL, 1, 1),
('102', NULL, 1, 2);

