-- 测试数据集2: 用户满意度调查（多题目测试）
USE smart_survey;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE answer_detail;
TRUNCATE TABLE user_response;
TRUNCATE TABLE option_item;
TRUNCATE TABLE question;
TRUNCATE TABLE questionnaire;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO questionnaire (id, title, description, create_time, status) 
VALUES (1, '产品用户满意度调查', '了解用户对我们产品的使用体验和满意度', NOW(), 1);

INSERT INTO question (id, content, type, question_order, questionnaire_id) VALUES 
(1, '您使用我们产品多久了？', 1, 1, 1),
(2, '您最常使用哪些功能？（可多选）', 2, 2, 1),
(3, '您对我们的产品整体满意度如何？', 1, 3, 1),
(4, '您认为产品哪些方面需要改进？', 2, 4, 1),
(5, '您有什么其他建议或意见？', 3, 5, 1);

INSERT INTO option_item (id, option_text, option_order, question_id) VALUES 
(101, '不到1个月', 1, 1),
(102, '1-3个月', 2, 1),
(103, '3-6个月', 3, 1),
(104, '6个月以上', 4, 1),
(201, '数据统计', 1, 2),
(202, '报表导出', 2, 2),
(203, '用户管理', 3, 2),
(204, '权限设置', 4, 2),
(205, '系统配置', 5, 2),
(301, '非常满意', 1, 3),
(302, '满意', 2, 3),
(303, '一般', 3, 3),
(304, '不满意', 4, 3),
(401, '界面设计', 1, 4),
(402, '功能完整性', 2, 4),
(403, '性能速度', 3, 4),
(404, '用户体验', 4, 4),
(405, '文档支持', 5, 4);

INSERT INTO user_response (id, responder_ip, submit_time, questionnaire_id) VALUES 
(1, '192.168.1.20', NOW(), 1),
(2, '192.168.1.21', NOW(), 1),
(3, '192.168.1.22', NOW(), 1),
(4, '192.168.1.23', NOW(), 1),
(5, '192.168.1.24', NOW(), 1);

INSERT INTO answer_detail (selected_option_ids, text_answer, question_id, response_id) VALUES 
('102', NULL, 1, 1),
('201,203', NULL, 2, 1),
('301', NULL, 3, 1),
('401,404', NULL, 4, 1),
(NULL, '希望增加更多自定义功能', 5, 1),
('103', NULL, 1, 2),
('202,205', NULL, 2, 2),
('302', NULL, 3, 2),
('402,403', NULL, 4, 2),
(NULL, '性能还可以再优化', 5, 2),
('101', NULL, 1, 3),
('201', NULL, 2, 3),
('303', NULL, 3, 3),
('404', NULL, 4, 3),
(NULL, '界面可以更美观', 5, 3),
('104', NULL, 1, 4),
('201,202,203', NULL, 2, 4),
('301', NULL, 3, 4),
('401', NULL, 4, 4),
(NULL, '整体不错，继续保持', 5, 4),
('102', NULL, 1, 5),
('203,204', NULL, 2, 5),
('304', NULL, 3, 5),
('402,403,405', NULL, 4, 5),
(NULL, '需要更多帮助文档', 5, 5);

