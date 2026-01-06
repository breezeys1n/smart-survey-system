-- 测试数据集5: 混合题型问卷（完整功能测试）
USE smart_survey;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE answer_detail;
TRUNCATE TABLE user_response;
TRUNCATE TABLE option_item;
TRUNCATE TABLE question;
TRUNCATE TABLE questionnaire;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO questionnaire (id, title, description, create_time, status) 
VALUES (1, '综合功能测试问卷', '测试所有题型和功能的完整问卷', NOW(), 1);

INSERT INTO question (id, content, type, question_order, questionnaire_id) VALUES 
(1, '您的职业是？', 1, 1, 1),
(2, '您使用过哪些编程语言？（可多选）', 2, 2, 1),
(3, '请简单介绍一下您的项目经验', 3, 3, 1),
(4, '您的工作年限是？', 1, 4, 1),
(5, '您关注哪些技术方向？（可多选）', 2, 5, 1),
(6, '您对当前工作的满意度如何？', 1, 6, 1),
(7, '您有什么职业规划？', 3, 7, 1);

INSERT INTO option_item (id, option_text, option_order, question_id) VALUES 
(101, '前端开发', 1, 1),
(102, '后端开发', 2, 1),
(103, '全栈开发', 3, 1),
(104, '移动开发', 4, 1),
(105, '其他', 5, 1),
(201, 'Java', 1, 2),
(202, 'Python', 2, 2),
(203, 'JavaScript', 3, 2),
(204, 'Go', 4, 2),
(205, 'C++', 5, 2),
(206, 'Rust', 6, 2),
(401, '1年以下', 1, 4),
(402, '1-3年', 2, 4),
(403, '3-5年', 3, 4),
(404, '5-10年', 4, 4),
(405, '10年以上', 5, 4),
(501, '人工智能', 1, 5),
(502, '区块链', 2, 5),
(503, '云计算', 3, 5),
(504, '大数据', 4, 5),
(505, '物联网', 5, 5),
(601, '非常满意', 1, 6),
(602, '满意', 2, 6),
(603, '一般', 3, 6),
(604, '不满意', 4, 6);

INSERT INTO user_response (id, responder_ip, submit_time, questionnaire_id) VALUES 
(1, '192.168.1.50', NOW(), 1),
(2, '192.168.1.51', NOW(), 1),
(3, '192.168.1.52', NOW(), 1),
(4, '192.168.1.53', NOW(), 1),
(5, '192.168.1.54', NOW(), 1),
(6, '192.168.1.55', NOW(), 1),
(7, '192.168.1.56', NOW(), 1),
(8, '192.168.1.57', NOW(), 1);

INSERT INTO answer_detail (selected_option_ids, text_answer, question_id, response_id) VALUES 
('103', NULL, 1, 1),
('201,203,204', NULL, 2, 1),
(NULL, '有5年全栈开发经验，主要使用Java和React', 3, 1),
('403', NULL, 4, 1),
('501,503', NULL, 5, 1),
('601', NULL, 6, 1),
(NULL, '希望成为技术专家，深入研究某个领域', 7, 1),
('102', NULL, 1, 2),
('202,203', NULL, 2, 2),
(NULL, '3年Python后端开发经验', 3, 2),
('402', NULL, 4, 2),
('501,504', NULL, 5, 2),
('602', NULL, 6, 2),
(NULL, '计划转向AI方向', 7, 2),
('101', NULL, 1, 3),
('203', NULL, 2, 3),
(NULL, '前端开发2年，主要使用Vue和React', 3, 3),
('402', NULL, 4, 3),
('503', NULL, 5, 3),
('602', NULL, 6, 3),
(NULL, '继续深耕前端，学习新技术', 7, 3),
('104', NULL, 1, 4),
('201,203', NULL, 2, 4),
(NULL, '移动开发经验丰富', 3, 4),
('404', NULL, 4, 4),
('502,505', NULL, 5, 4),
('601', NULL, 6, 4),
(NULL, '考虑转全栈', 7, 4),
('103', NULL, 1, 5),
('201,202,203,204', NULL, 2, 5),
(NULL, '全栈开发，技术栈广泛', 3, 5),
('405', NULL, 4, 5),
('501,502,503,504', NULL, 5, 5),
('601', NULL, 6, 5),
(NULL, '希望成为技术负责人', 7, 5),
('102', NULL, 1, 6),
('201,205', NULL, 2, 6),
(NULL, 'C++和Java后端开发', 3, 6),
('403', NULL, 4, 6),
('503', NULL, 5, 6),
('603', NULL, 6, 6),
(NULL, '继续提升技术深度', 7, 6),
('101', NULL, 1, 7),
('203', NULL, 2, 7),
(NULL, '前端新手，刚入门', 3, 7),
('401', NULL, 4, 7),
('501', NULL, 5, 7),
('604', NULL, 6, 7),
(NULL, '努力学习，快速成长', 7, 7),
('105', NULL, 1, 8),
('206', NULL, 2, 8),
(NULL, 'Rust系统开发', 3, 8),
('402', NULL, 4, 8),
('502', NULL, 5, 8),
('602', NULL, 6, 8),
(NULL, '专注于系统编程', 7, 8);

