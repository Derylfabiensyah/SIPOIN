# Requirements Document

## Introduction

Sistem Poin Siswa adalah aplikasi yang memungkinkan guru untuk memberikan poin kepada siswa berdasarkan pelanggaran atau prestasi yang dilakukan. Sistem ini menyediakan mekanisme pencatatan yang transparan dimana setiap pemberian poin dicatat dengan informasi lengkap termasuk guru yang memberikan, jenis aktivitas (pelanggaran/prestasi), dan jumlah poin. Siswa dapat melihat riwayat poin mereka melalui dashboard yang menampilkan detail setiap transaksi poin dalam format yang mudah dipahami dengan tampilan berbasis kartu (card-based UI).

## Glossary

- **System**: Sistem Poin Siswa - aplikasi untuk mengelola poin pelanggaran dan prestasi siswa
- **Point_Management_Service**: Service yang menangani logika bisnis pemberian poin oleh guru
- **Point_Query_Service**: Service yang menyediakan query untuk menampilkan data poin siswa
- **Point_Repository**: Komponen yang menangani akses data untuk point records
- **Validation_Service**: Service yang melakukan validasi data sebelum operasi bisnis
- **Point_Record**: Record yang menyimpan informasi pemberian poin (student, teacher, type, points, reason, timestamp)
- **Dashboard**: Tampilan ringkasan poin siswa dengan dua kartu (Pelanggaran dan Prestasi)
- **Detail_View**: Tampilan detail yang menampilkan list individual point records dengan informasi lengkap
- **Violation**: Pelanggaran - jenis poin negatif yang mengurangi total poin siswa
- **Achievement**: Prestasi - jenis poin positif yang menambah total poin siswa
- **Teacher**: Pengguna dengan role guru yang dapat memberikan poin kepada siswa
- **Student**: Pengguna dengan role siswa yang dapat melihat dashboard poin mereka sendiri
- **Admin**: Pengguna dengan role admin yang dapat melihat semua data dan melakukan revoke points

## Requirements

### Requirement 1: Point Assignment by Teacher

**User Story:** As a teacher, I want to assign points to students with a reason, so that I can record violations or achievements with proper documentation.

#### Acceptance Criteria

1. WHEN a teacher assigns a point to a student, THE Point_Management_Service SHALL create a Point_Record with student ID, teacher ID, point type, point value, reason, and timestamp
2. WHEN a teacher assigns a point, THE Validation_Service SHALL validate that the student ID exists in the system
3. WHEN a teacher assigns a point, THE Validation_Service SHALL validate that the teacher ID exists and has teacher role
4. WHEN a teacher assigns a point, THE Validation_Service SHALL validate that the point value is greater than 0 and less than or equal to 100
5. WHEN a teacher assigns a point, THE Validation_Service SHALL validate that the reason has at least 5 characters
6. IF validation fails, THEN THE Point_Management_Service SHALL return an error message without creating a Point_Record
7. WHEN a Point_Record is successfully created, THE System SHALL log the activity with teacher ID and timestamp

### Requirement 2: Point Type Classification

**User Story:** As a teacher, I want to specify whether points are for violations or achievements, so that the system can properly categorize and calculate student points.

#### Acceptance Criteria

1. WHEN a teacher assigns a point, THE System SHALL require the teacher to specify the point type as either Violation or Achievement
2. WHEN a point type is Violation, THE System SHALL treat the point value as negative in total calculations
3. WHEN a point type is Achievement, THE System SHALL treat the point value as positive in total calculations
4. THE System SHALL store the point type in the Point_Record for filtering and display purposes

### Requirement 3: Student Dashboard Display

**User Story:** As a student, I want to view my point summary in a dashboard, so that I can see my total violations and achievements at a glance.

#### Acceptance Criteria

1. WHEN a student accesses the dashboard, THE Point_Query_Service SHALL retrieve all active Point_Records for that student
2. WHEN displaying the dashboard, THE System SHALL calculate total violation points by summing all Violation type points
3. WHEN displaying the dashboard, THE System SHALL calculate total achievement points by summing all Achievement type points
4. WHEN displaying the dashboard, THE System SHALL calculate net points as achievement points minus violation points
5. WHEN displaying the dashboard, THE System SHALL show two cards: one for Pelanggaran (violations) and one for Prestasi (achievements)
6. WHEN displaying the Pelanggaran card, THE System SHALL show the total violation points
7. WHEN displaying the Prestasi card, THE System SHALL show the total achievement points
8. WHEN displaying the dashboard, THE System SHALL show the net points value

### Requirement 4: Point Detail View by Type

**User Story:** As a student, I want to click on the Pelanggaran or Prestasi card to see detailed records, so that I can understand what specific violations or achievements contributed to my points.

#### Acceptance Criteria

1. WHEN a student clicks the Pelanggaran card, THE System SHALL navigate to the Detail_View showing only Violation type records
2. WHEN a student clicks the Prestasi card, THE System SHALL navigate to the Detail_View showing only Achievement type records
3. WHEN displaying the Detail_View, THE Point_Query_Service SHALL filter Point_Records by student ID and point type
4. WHEN displaying the Detail_View, THE System SHALL show only active Point_Records
5. WHEN displaying each record in Detail_View, THE System SHALL show the reason, point value, teacher name, and timestamp
6. WHEN displaying the Detail_View, THE System SHALL resolve teacher names from teacher IDs
7. WHEN displaying the Detail_View, THE System SHALL sort records by timestamp in descending order (newest first)
8. WHEN displaying the Detail_View, THE System SHALL show the total points for that type at the top

### Requirement 5: Teacher Name Resolution

**User Story:** As a student, I want to see which teacher gave me each point, so that I know who recorded each violation or achievement.

#### Acceptance Criteria

1. WHEN displaying point records in any view, THE System SHALL resolve teacher IDs to teacher names
2. WHEN a teacher name cannot be resolved, THE System SHALL display a default text indicating the teacher information is unavailable
3. THE System SHALL cache teacher names to minimize repeated queries to the User Service

### Requirement 6: Access Control for Students

**User Story:** As a student, I want to ensure that I can only view my own point data, so that my privacy is protected.

#### Acceptance Criteria

1. WHEN a student accesses the dashboard, THE System SHALL verify that the authenticated user is the same as the student whose data is being requested
2. IF a student attempts to access another student's data, THEN THE System SHALL return an authorization error
3. WHEN a student accesses the Detail_View, THE System SHALL verify that the authenticated user is the same as the student whose data is being requested

### Requirement 7: Access Control for Teachers

**User Story:** As a teacher, I want to be able to assign points but not view student dashboards, so that the dashboard remains a student-only feature.

#### Acceptance Criteria

1. WHEN a user with teacher role attempts to assign points, THE System SHALL allow the operation if all validations pass
2. WHEN a user with teacher role attempts to access a student dashboard, THE System SHALL deny the operation
3. THE System SHALL restrict dashboard viewing to student role and admin role only

### Requirement 8: Point Record Immutability

**User Story:** As a system administrator, I want point records to be immutable by default, so that there is a reliable audit trail.

#### Acceptance Criteria

1. WHEN a Point_Record is created, THE System SHALL assign it an active status
2. THE System SHALL not allow modification of existing Point_Record fields (student ID, teacher ID, points, reason, timestamp)
3. WHERE revocation is needed, THE System SHALL change the status to revoked instead of deleting the record
4. WHEN calculating totals, THE System SHALL only include Point_Records with active status

### Requirement 9: Point Record Persistence

**User Story:** As a teacher, I want all point assignments to be saved immediately, so that no data is lost.

#### Acceptance Criteria

1. WHEN a Point_Record is created, THE Point_Repository SHALL persist it to the database immediately
2. IF database persistence fails, THEN THE System SHALL return an error to the teacher
3. WHEN a Point_Record is successfully persisted, THE System SHALL return the complete Point_Record with generated ID

### Requirement 10: Data Validation Rules

**User Story:** As a system administrator, I want strict validation rules enforced, so that data integrity is maintained.

#### Acceptance Criteria

1. THE System SHALL enforce that Point_Record IDs are unique UUIDs
2. THE System SHALL enforce that student IDs reference valid students in the system
3. THE System SHALL enforce that teacher IDs reference valid teachers in the system
4. THE System SHALL enforce that point values are integers greater than 0 and less than or equal to 100
5. THE System SHALL enforce that reasons are non-empty strings with at least 5 characters
6. THE System SHALL enforce that timestamps are not in the future
7. THE System SHALL enforce that point types are either Violation or Achievement

### Requirement 11: Dashboard Data Consistency

**User Story:** As a student, I want my dashboard to show accurate calculations, so that I can trust the displayed point totals.

#### Acceptance Criteria

1. WHEN displaying the dashboard, THE System SHALL ensure that total points equals achievement points minus violation points
2. WHEN displaying the dashboard, THE System SHALL ensure that violation points are non-negative
3. WHEN displaying the dashboard, THE System SHALL ensure that achievement points are non-negative
4. WHEN calculating totals, THE System SHALL only include Point_Records with active status

### Requirement 12: Temporal Ordering

**User Story:** As a student, I want to see my most recent point records first, so that I can quickly understand my latest violations or achievements.

#### Acceptance Criteria

1. WHEN displaying records in the Detail_View, THE System SHALL sort them by timestamp in descending order
2. WHEN displaying recent records on the dashboard, THE System SHALL sort them by timestamp in descending order
3. THE System SHALL ensure that for any two consecutive records in the display, the first record's timestamp is greater than or equal to the second record's timestamp

### Requirement 13: Error Handling for Invalid Student

**User Story:** As a teacher, I want clear error messages when I try to assign points to an invalid student, so that I can correct my input.

#### Acceptance Criteria

1. IF a teacher attempts to assign points to a non-existent student ID, THEN THE System SHALL return an error message "Student not found"
2. IF validation fails, THEN THE System SHALL not create a Point_Record
3. WHEN an error occurs, THE System SHALL return the error message to the UI for display

### Requirement 14: Error Handling for Invalid Points

**User Story:** As a teacher, I want validation feedback on point values, so that I enter valid data.

#### Acceptance Criteria

1. IF a teacher attempts to assign points with a value less than or equal to 0, THEN THE System SHALL return a validation error
2. IF a teacher attempts to assign points with a value greater than 100, THEN THE System SHALL return a validation error
3. WHEN point validation fails, THE System SHALL not create a Point_Record

### Requirement 15: Error Handling for Database Failures

**User Story:** As a teacher, I want to be notified if point assignment fails due to technical issues, so that I can retry or report the problem.

#### Acceptance Criteria

1. IF the database connection fails during point assignment, THEN THE System SHALL return an error message indicating the failure
2. IF the database connection fails during dashboard query, THEN THE System SHALL return an error message indicating the failure
3. WHEN a database error occurs, THE System SHALL log the error with details for troubleshooting

### Requirement 16: Navigation Between Views

**User Story:** As a student, I want to navigate from the dashboard to detail views and back, so that I can explore my point records easily.

#### Acceptance Criteria

1. WHEN a student clicks the Pelanggaran card on the dashboard, THE System SHALL navigate to the Pelanggaran Detail_View
2. WHEN a student clicks the Prestasi card on the dashboard, THE System SHALL navigate to the Prestasi Detail_View
3. WHEN a student clicks the back button in the Detail_View, THE System SHALL navigate back to the dashboard
4. WHEN navigating back to the dashboard, THE System SHALL refresh the dashboard data to reflect any changes

### Requirement 17: Empty State Handling

**User Story:** As a student with no point records, I want to see an appropriate message, so that I understand my current status.

#### Acceptance Criteria

1. WHEN a student has no Point_Records, THE System SHALL display the dashboard with zero values for all point totals
2. WHEN a student has no Violation records, THE Pelanggaran card SHALL show 0 points
3. WHEN a student has no Achievement records, THE Prestasi card SHALL show 0 points
4. WHEN viewing a Detail_View with no records, THE System SHALL display an empty list or appropriate message

### Requirement 18: Point Record Completeness

**User Story:** As a student, I want to ensure that all my point records are accounted for in the dashboard, so that nothing is missing.

#### Acceptance Criteria

1. WHEN displaying the dashboard, THE System SHALL include all active Point_Records for the student
2. THE sum of records shown in Pelanggaran Detail_View and Prestasi Detail_View SHALL equal the total number of active Point_Records for the student
3. THE System SHALL not exclude any active Point_Records from calculations or displays

### Requirement 19: Activity Logging

**User Story:** As a system administrator, I want all point assignments to be logged, so that I can audit teacher activities.

#### Acceptance Criteria

1. WHEN a teacher assigns a point, THE System SHALL create an activity log entry with teacher ID, action type, Point_Record ID, and timestamp
2. THE System SHALL persist activity logs independently of Point_Records
3. WHEN a point is revoked, THE System SHALL create an activity log entry with the revocation details

### Requirement 20: Point Revocation by Admin

**User Story:** As an administrator, I want to revoke incorrectly assigned points, so that I can correct mistakes.

#### Acceptance Criteria

1. WHERE an admin role is authenticated, WHEN the admin revokes a point, THE System SHALL change the Point_Record status to revoked
2. WHEN a Point_Record is revoked, THE System SHALL exclude it from all point calculations
3. WHEN a Point_Record is revoked, THE System SHALL maintain the original record data for audit purposes
4. WHEN a Point_Record is revoked, THE System SHALL log the revocation with admin ID and timestamp
