SELECT title FROM courses WHERE level = 'beginner' AND price < 10000 ORDER BY price;
-- название курсов с начальным уровнем и ценой меньше 10000

SELECT COUNT(enrollment_id) FROM enrollments WHERE status = 'completed';
-- количество завершённых записей на курсы

SELECT full_name, COUNT(course_id) AS count_courses FROM teachers LEFT JOIN courses USING(teacher_id) GROUP BY teacher_id, full_name ORDER BY count_courses DESC;
-- имя преподавателя и количество курсов которое он ведет



SELECT title, SUM(amount) AS sum_course FROM courses JOIN enrollments USING(course_id) JOIN payments USING(enrollment_id) WHERE payments.status = 'success' GROUP BY course_id, title HAVING SUM(amount) > 50000 ORDER BY sum_course DESC;
-- Сумма успешных платежей (status = 'success') по каждому курсу. Включены курсы, где эта сумма больше 50 000

SELECT full_name, city FROM students WHERE student_id IN (SELECT student_id FROM enrollments WHERE status = 'cancelled') AND student_id NOT IN (SELECT student_id FROM enrollments WHERE status = 'completed');
-- студенты, у которых есть хотя бы один cancelled enrollment, но при этом нет ни одного completed

SELECT title, ROUND(AVG(progress_percent), 2) AS avg_progress_percent FROM courses JOIN enrollments USING(course_id) WHERE status = 'active' GROUP BY course_id, title HAVING COUNT(enrollment_id) >= 5 ORDER BY avg_progress_percent DESC;
--средний progress_percent среди записей со статусом active, где активных записей не меньше 5



SELECT title, full_name, SUM(amount) AS sum_course FROM courses JOIN teachers USING(teacher_id) JOIN enrollments USING(course_id) JOIN payments USING(enrollment_id) WHERE payments.status = 'success' AND level = 'intermediate' AND paid_at >= '2026-01-01' AND paid_at < '2027-01-01' GROUP BY course_id, title, full_name ORDER BY sum_course DESC LIMIT 3;
-- топ-3 курса по выручке (только success-платежи) среди курсов уровня intermediate, но учтены только платежи, сделанные в 2026 году

SELECT full_name, COUNT(enrollment_id) AS completed_count FROM students JOIN enrollments USING(student_id) WHERE status = 'completed' GROUP BY student_id, full_name HAVING COUNT(enrollment_id) > (SELECT AVG(count_completed) FROM (SELECT COUNT(enrollment_id) AS count_completed FROM enrollments WHERE status = 'completed' GROUP BY student_id) AS T1);
-- Студенты, у которых завершённых записей (completed) больше, чем в среднем среди студентов, завершивших хотя бы один курс

WITH T1 AS (SELECT title, level, SUM(amount) AS sum_payments_for_course FROM courses JOIN enrollments USING(course_id) JOIN payments USING(enrollment_id) WHERE payments.status = 'success' GROUP BY course_id, title, level)
SELECT title, level, sum_payments_for_course, RANK() OVER (PARTITION BY level ORDER BY sum_payments_for_course DESC) AS place_in_level, ROUND(sum_payments_for_course/(SUM(sum_payments_for_course) OVER (PARTITION BY LEVEL))*100, 2) AS percent_sum_payments from T1;
-- как курсы соотносятся друг с другом по выручке внутри своего уровня сложности