### Questions

1. **Joins:**
   - Write a query to retrieve a list of students along with their enrolled courses. Include the student’s first name, last name, and the course name. Ensure to use the appropriate join type.

2. **Data Conversion:**
   - Write a query that converts the `Grade` from the `Enrollments` table into a letter grade (A, B, C, D, F) using a CASE statement and return the student's first name, last name, and the corresponding letter grade.

3. **Aggregate Functions:**
   - Write a query to find the average grade of students for each course. Return the course name and the average grade. 

4. **Window Functions:**
   - Write a query to rank students based on their grades within each course. Return the student's full name, course name, grade, and their rank in the course.

5. **Filtering with Aggregate Functions:**
   - Write a query to list courses that have an average student grade greater than 3.5. Return the course name and the average grade.

6. **Using CASE with Aggregate Functions:**
   - Write a query that calculates the total number of students with grades above 3.0 and those below or equal to 3.0 for each course. Use a CASE statement to categorize the grades and return the course name with the counts.

7. **Group By with Aggregate Functions:**
   - Write a query that returns the number of students enrolled in each course. Include the course name and the total student count.

8. **Joining Multiple Tables:**
   - Write a query that returns a list of all teachers along with the courses they teach. Include the teacher's first name, last name, and the course name.

9. **Conditional Aggregation:**
   - Write a query that displays the total number of students who are active (IsActive = 1) and the total number of inactive students for each course. Return the course name along with both counts.

10. **Data Conversion with Date:**
    - Write a query that formats the `EnrollmentDate` to a more readable format (e.g., 'Month Day, Year') and returns the student’s full name along with the formatted enrollment date.

### Bonus Question
11. **Nested Queries:**
    - Write a query that retrieves the names of students who are enrolled in courses where the average grade is above 3.5. Use a subquery to get the average grades of the courses first.