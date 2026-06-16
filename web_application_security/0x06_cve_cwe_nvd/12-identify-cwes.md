# Identify CWEs in a Code Snippet

By Parshana Danesh

The given code snippet connects to a SQLite database and searches for a user by username. The main security problem is that the username value is directly added into the SQL query.

The vulnerable line is:

query = "SELECT * FROM users WHERE username='" + username + "';"
cursor.execute(query)

This is dangerous because the application trusts user input and places it directly into a database command. If an attacker controls the username value, they may be able to change the meaning of the SQL query.

## Identified CWEs

The main CWE present in this code is CWE-89: Improper Neutralization of Special Elements used in an SQL Command, also known as SQL Injection.

This weakness happens when user input is included in a SQL query without proper protection. In this example, the username is joined directly with the SQL string. Because of that, an attacker could provide input that changes the query logic.

A related weakness is CWE-20: Improper Input Validation. The code does not check or validate the username before using it in the SQL query. However, the primary weakness is CWE-89 because the main risk is SQL Injection.

## Attack Scenario

An attacker could enter a username like:

' OR '1'='1

This could change the SQL query and make it return a user even if the attacker did not provide a valid username.

The final query could become something like:

SELECT * FROM users WHERE username='' OR '1'='1';

Because '1'='1' is always true, the database may return a user record. In a real application, this could lead to unauthorized access or information disclosure.

## Security Impact

The impact of this weakness can be serious. SQL Injection can allow attackers to read sensitive data from the database, bypass authentication, modify records, delete information, or cause unexpected application behavior.

In this specific code, the attacker may be able to retrieve user information without knowing a valid username. If the same pattern is used in login or admin functions, the risk becomes even higher.

This weakness affects confidentiality because user data may be exposed. It can also affect integrity if attackers are able to change database records. In some cases, it may also affect availability if attackers cause database errors or delete data.

## Recommended Code Fix

The correct mitigation is to use parameterized queries instead of building SQL strings manually.

A safer version of the query would be:

query = "SELECT * FROM users WHERE username = ?"
cursor.execute(query, (username,))

In this safer version, the placeholder separates the SQL command from the user input. The database treats the username as data, not as part of the SQL command.

## Additional Security Controls

Developers should also validate input before using it. For example, usernames can be limited to expected characters and reasonable length.

The application should use least privilege for the database account. The account should only have the permissions it really needs.

Error messages should also be handled carefully. The application should not expose raw database errors to users because attackers can use those errors to learn more about the system.

## Final Thoughts

The main CWE in this code is CWE-89, SQL Injection. The related weakness is CWE-20, Improper Input Validation.

The code is vulnerable because it builds a SQL query by directly combining user input with the query string. This can allow attackers to manipulate the SQL command.

The best fix is to use parameterized queries, validate user input, apply least privilege, and avoid exposing database errors. These changes help protect the database and reduce the risk of unauthorized access.

## References

- CWE-89: SQL Injection
- CWE-20: Improper Input Validation
- CVE Program
- National Vulnerability Database
- Digital Learning Hub project material
