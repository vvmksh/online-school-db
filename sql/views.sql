CREATE OR REPLACE VIEW v_course_revenue AS SELECT title, SUM(amount) AS sum_course FROM courses JOIN enrollments USING(course_id) JOIN payments USING(enrollment_id) WHERE payments.status = 'success' GROUP BY course_id, title HAVING SUM(amount) > 50000 ORDER BY sum_course DESC;

SELECT * FROM v_course_revenue;