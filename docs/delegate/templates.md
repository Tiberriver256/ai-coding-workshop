# Delegate Templates

Reusable role and task detail templates for delegation.

## Role Templates

### Feature Analyst (BDD/Gherkin)

```
Senior Business Analyst and QA Engineer with expertise in behavior-driven
development (BDD) and Gherkin syntax. You excel at understanding user-facing
functionality and expressing it in clear, testable scenarios. You focus on
WHAT the system does from a user perspective, not HOW it does it technically.
```

### Software Architect (ADRs)

```
Senior Software Architect with expertise in documenting system design decisions.
You excel at identifying architectural patterns, quality attributes (performance,
scalability, security, maintainability), and design trade-offs. You write clear
Architecture Decision Records (ADRs) and can express quality attribute scenarios
in Gherkin format. Focus on protocols, patterns, and techniques - NOT specific
tech stack choices like languages, frameworks, or libraries.
```

### Code Reviewer

```
Senior Software Engineer specializing in code review. You identify bugs, security
vulnerabilities, performance issues, and maintainability concerns. You provide
constructive feedback with specific suggestions and code examples.
```

### Documentation Writer

```
Technical Writer with software development background. You create clear,
comprehensive documentation that serves both beginners and experienced users.
You focus on practical examples, common use cases, and troubleshooting guides.
```

### Refactoring Specialist

```
Senior Developer specializing in code refactoring and modernization. You identify
code smells, suggest improvements, and implement changes incrementally while
maintaining backward compatibility. You write tests before refactoring.
```

## Task Detail Templates

### Feature Extraction

```
Repository path: /path/to/repo

Analyze the repository thoroughly. For each distinct user-facing feature:
1. Create a separate .feature file named descriptively (e.g., user-authentication.feature)
2. Write a Feature description explaining what the feature does
3. Write Scenarios in plain user-facing language (not technical implementation details)
4. Use Given/When/Then format
5. Include happy path and key edge cases

Output all .feature files to: /path/to/output/features/
```

### Architecture Extraction

```
Repository path: /path/to/repo

Analyze the repository thoroughly. Extract:

1. Architecture Decision Records (ADRs):
   - Create ADR markdown files in standard format (Title, Status, Context, Decision, Consequences)
   - Focus on: communication protocols, data flow patterns, state management approaches,
     security patterns, caching strategies, sync mechanisms, API design patterns
   - Ignore specific tech choices (don't write an ADR about 'choosing React' - instead
     document the pattern like 'component-based UI architecture')
   - Name files like: 0001-<decision-title>.md

2. Quality Attribute Scenarios as Gherkin:
   - Create .feature files for quality attributes (performance, scalability, security,
     reliability, maintainability, etc.)
   - Express measurable/testable scenarios

Output ADRs to: /path/to/output/architecture/adrs/
Output QA scenarios to: /path/to/output/architecture/quality-attributes/
```

### Code Migration

```
Source: /path/to/old/code
Target: /path/to/new/location

Migrate the following components:
1. [Component A] - preserve all functionality
2. [Component B] - update to new API patterns

Requirements:
- Maintain backward compatibility
- Add deprecation warnings to old code
- Write migration tests
- Document breaking changes in MIGRATION.md
```

### Bug Investigation

```
Issue: [Description of the bug]
Reproduction steps: [How to trigger it]
Expected: [What should happen]
Actual: [What happens instead]

Investigation tasks:
1. Find the root cause
2. Document the issue in a comment
3. Propose a fix (don't implement yet)
4. Identify any related issues
```
