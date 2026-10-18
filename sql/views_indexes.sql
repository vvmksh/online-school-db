CREATE INDEX idx_enrollments_course_id ON enrollments (course_id);
CREATE INDEX idx_payments_enrollment_id ON payments (enrollment_id);
CREATE INDEX idx_payments_paid_at ON payments (paid_at);

ANALYZE enrollments;
ANALYZE payments;