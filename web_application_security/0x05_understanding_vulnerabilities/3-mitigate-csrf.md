# Stop CSRF: Preventing Unwanted Actions Through Trusted Sessions

By Parshana Danesh

Cross-Site Request Forgery or CSRF is a problem for websites. It is when someone tricks a user into doing something they do not want to do. The bad part is that the request looks like it comes from the users browser so the website thinks it is okay.

Let me give you an example. Imagine a user is logged in to their banking website. If they visit a website in another tab that bad website might try to send a request to the banking site. If the banking site only looks at the users session cookie the browser might automatically send that cookie. Without protection the website might think the user really meant to do that.

## What Is CSRF?

CSRF happens when a website trusts a request just because it has a session cookie. The bad guy does not need to know the users password. They just use the fact that the user is already logged in.

This is like someone using your hand to sign a paper you do not want to sign.

CSRF usually goes after actions that change something like changing an email address updating a password sending money deleting data or changing account settings.

This makes CSRF different from kinds of attacks like XSS. In XSS the bad guy puts code into a webpage. In CSRF the bad guy tricks the browser into sending a request the user did not mean to send.

## How Did This Happen?

CSRF became a problem as websites started using cookies and logged-in sessions more. Old websites often trusted requests if they had a session cookie. That was a problem because browsers automatically add cookies to requests.

As websites got more interactive bad guys found ways to abuse this. Over time website builders and security experts started adding protection against CSRF like tokens and better cookie controls.

Today CSRF is a problem but it still happens when developers forget to protect important actions or only use cookies to check who is logged in.

## What Happens If CSRF Attacks Succeed?

The impact of a CSRF attack depends on what the user's allowed to do. If the victim is an user the bad guy might change account details submit forms make purchases or change personal data.

If the victim is an administrator the impact can be much worse. A successful CSRF attack on an account might let the bad guy change website settings create new users, delete content or take over the whole system.

For technology companies CSRF can lead to actions, data changes, account problems, loss of trust and legal issues. Even if the bad guy does not steal a password they can still abuse the users logged-in session.

## How To Stop CSRF

The common way to stop CSRF is to use special tokens. A CSRF token is a code made by the website. The website includes the token in forms or requests. Checks it before doing anything.

If a bad guy tries to fake a request from another site they usually cannot know the correct token. This helps the website reject the request.

Another important way to stop CSRF is to check where requests come from. Websites can check headers like Origin or Referer to make sure sensitive requests come from trusted pages.

Websites can also use cookies that limit when browsers send them in cross-site requests. This makes it harder for another website to abuse the users logged-in session.

Websites should also make sure cookies are secure. Cookies should only be accessible by the website. Should only be sent over secure connections.

Websites should not use GET requests for actions that change something. GET should only be used for reading data not for changing passwords or submitting actions.

For sensitive actions websites should require extra confirmation, like re-entering a password or using two-factor authentication.

## Best Practices

To reduce CSRF risk developers should use built-in protection from their website builder whenever possible. Custom security code can easily have mistakes.

They should also protect all actions that change something not login forms. Important actions like profile updates, payment actions, password changes and admin operations must be protected.

Security testing is also important. Tools like Burp Suite and OWASP ZAP can help test whether forms and requests are protected against CSRF. Code review can also help developers make sure sensitive actions require tokens and proper request validation.

##

CSRF is a problem because it abuses the trust between the users browser and a website. The user might be logged in. That does not always mean they meant to do something.

The best ways to stop CSRF include tokens checking where requests come from, special cookies, secure cookies avoiding actions that change something with GET requests and extra confirmation, for sensitive actions.

Stopping CSRF should be part of making websites secure. Protecting logged-in actions helps keep websites safe and secure.

Next I will talk about patches and patch management. Explain how organizations fix known problems and reduce long-term security risk.

## References

* Digital Learning Hub: Understanding Vulnerabilities concept material

* OWASP Cross-Site Request Forgery documentation

* OWASP Cross-Site Request Forgery Prevention Cheat Sheet

* OWASP Authentication Cheat Sheet

* web.dev Safe and Secure documentation

* Burp Suite documentation

* OWASP ZAP documentation
