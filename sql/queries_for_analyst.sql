SELECT title FROM courses WHERE level = 'beginner' AND price < 10000 ORDER BY price; -- название курсов с начальным уровнем и ценой меньше 10000

SELECT COUNT(enrollment_id) FROM enrollments WHERE status = 'completed'; -- количество завершённых записей на курсы

SELECT full_name, COUNT(course_id) AS count_courses FROM teachers LEFT JOIN courses USING(teacher_id) GROUP BY teacher_id, full_name ORDER BY count_courses DESC; -- имя преподавателя и количество курсов которое он ведет



SELECT title, SUM(amount) AS sum_course FROM courses JOIN enrollments USING(course_id) JOIN payments USING(enrollment_id) WHERE payments.status = 'success' GROUP BY course_id, title HAVING SUM(amount) > 50000 ORDER BY sum_course DESC; -- Сумма успешных платежей (status = 'success') по каждому курсу. Включены курсы, где эта сумма больше 50 000

SELECT full_name, city FROM students WHERE student_id IN (SELECT student_id FROM enrollments WHERE status = 'cancelled') AND student_id NOT IN (SELECT student_id FROM enrollments WHERE status = 'completed'); -- студенты, у которых есть хотя бы один cancelled enrollment, но при этом нет ни одного completed

SELECT title, ROUND(AVG(progress_percent), 2) AS avg_progress_percent FROM courses JOIN enrollments USING(course_id) WHERE status = 'active' AND course_id IN (SELECT course_id FROM enrollments WHERE status = 'active' GROUP BY course_id HAVING COUNT(enrollment_id) >= 5) GROUP BY course_id, title ORDER BY avg_progress_percent DESC; --средний progress_percent среди записей со статусом active, где активных записей не меньше 5



SELECT title, full_name, SUM(amount) AS sum_course FROM courses JOIN teachers USING(teacher_id) JOIN enrollments USING(course_id) JOIN payments USING(enrollment_id) WHERE payments.status = 'success' AND level = 'intermediate' AND DATE_PART('year', paid_at) = 2026 GROUP BY title, full_name ORDER BY sum_course DESC LIMIT 3; -- топ-3 курса по выручке (только success-платежи) среди курсов уровня intermediate, но учтены только платежи, сделанные в 2026 году

SELECT full_name, COUNT(enrollment_id) AS completed_count FROM students JOIN enrollments USING(student_id) WHERE status = 'completed' GROUP BY student_id, full_name HAVING COUNT(enrollment_id) > (SELECT AVG(count_completed) FROM (SELECT COUNT(enrollment_id) AS count_completed FROM enrollments WHERE status = 'completed' GROUP BY student_id) AS T1); -- для каждого студента определено, сколько у него completed-записей, и выведены студенты, у которых число completed больше среднего числа completed по всем студентам

SELECT title, price, COUNT(enrollment_id) AS count_active_enrollment FROM courses JOIN enrollments USING(course_id) WHERE status = 'active' AND progress_percent > 50 AND course_id NOT IN (SELECT course_id FROM enrollments JOIN payments USING(enrollment_id) WHERE payments.status = 'success') GROUP BY course_id, title, price ORDER BY count_active_enrollment DESC; -- найдены курсы, у которых нет ни одного успешного платежа (success), но при этом есть хотя бы одна запись со статусом active и progress_percent > 50
