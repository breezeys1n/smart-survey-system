-- 测试数据集1: 程序员现状调查（基础测试）
USE smart_survey;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE answer_detail;
TRUNCATE TABLE user_response;
TRUNCATE TABLE option_item;
TRUNCATE TABLE question;
TRUNCATE TABLE questionnaire;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO questionnaire (id, title, description, create_time, status) 
VALUES (1, '2025年程序员现状调查', '本问卷旨在了解开发者的技能栈与满意度', NOW(), 1);

INSERT INTO question (id, content, type, question_order, questionnaire_id) VALUES 
(1, '你最常用的编程语言是什么？', 1, 1, 1),
(2, '你感兴趣的技术领域有哪些？', 2, 2, 1),
(3, '你对目前的工作环境有什么建议？', 3, 3, 1);

INSERT INTO option_item (id, option_text, option_order, question_id) VALUES 
(101, 'Java', 1, 1),
(102, 'Python', 2, 1),
(103, 'Go', 3, 1),
(104, 'PHP', 4, 1), 
(201, '人工智能', 1, 2),
(202, '大数据分析', 2, 2),
(203, '云原生/容器化', 3, 2),
(204, '前端开发', 4, 2);

INSERT INTO user_response (id, responder_ip, submit_time, questionnaire_id) VALUES 
(1, '192.168.1.5', NOW(), 1),
(2, '192.168.1.10', NOW(), 1),
(3, '192.168.1.15', NOW(), 1);

INSERT INTO answer_detail (selected_option_ids, text_answer, question_id, response_id) VALUES 
('101', NULL, 1, 1),
('201,203', NULL, 2, 1),
(NULL, '希望增加更多带薪年假', 3, 1),
('101', NULL, 1, 2),
('202,203', NULL, 2, 2),
(NULL, '公司零食种类可以再多一点', 3, 2),
('102', NULL, 1, 3);

