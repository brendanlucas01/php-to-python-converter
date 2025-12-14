# Project: The Self-Correcting Code Refactorer

### Scenario
At 'L Squared Digital Signage', we're building a new developer tool called **'Legacy Lifter'**. Its purpose is to automatically refactor complex, legacy PHP functions using a Large Language Model (LLM) to convert them to Python while maintaining full functionality.

### Your Task
Your goal is to implement a robust **verification pipeline** that:
1. Takes PHP legacy code as input
2. Uses an LLM to convert it to Python
3. Verifies the converted code maintains identical functionality
4. Ensures all API endpoints remain functional

### Requirements

1. **Source Analysis**
   - Analyze existing PHP endpoints and their functionality
   - Document API contracts and expected behaviors
   - Map database interactions and external service calls

   Available Endpoints:
   ```
   - GET http://localhost:8080/              # Root endpoint
   - GET http://localhost:8080/devices/      # List devices
   - GET http://localhost:8080/devices/briefs/:deviceId  # Get device details
   - POST http://localhost:8080/action/devices  # Update device status
   ```

   Example POST payload for `/action/devices`:
   ```json
   [
       {
           "id": 106,
           "type": "device",
           "subType": "device",
           "status": "offline"
       }
   ]
   ```
   
   Note: These endpoints will be available automatically when you start the development environment.

2. **LLM Integration**
   - Integrate OpenAI's LLM API (access token available as `$API_KEY` in environment)
   - Design prompts for PHP to Python conversion
   - Handle error cases and malformed outputs

3. **Verification Pipeline**
   - Create test cases that verify endpoint parity
   - Ensure database operations work identically
   - Validate API responses match original PHP implementation
   - Check performance metrics

4. **Quality Assurance**
   - Implement comprehensive test coverage
   - Validate syntax and code quality
   - Verify error handling matches PHP implementation
   - Document any behavioral differences

### Deliverables
1. Python codebase with converted functionality
2. Test suite demonstrating endpoint parity
3. Documentation of your verification pipeline
4. Migration report highlighting any challenges or differences

### Questions (Please answer below this line)

1. **Describe your verification approach.** How did you ensure the Python code maintains the same functionality as the PHP code?

2. **What challenges did you face** in maintaining consistency between PHP and Python implementations?

3. **How would your system handle PHP-specific features** that don't have direct Python equivalents?

4. **What additional verification steps** would you add given more time?

Note: The implementation details and project structure are left to your discretion. Focus on creating a robust verification system that ensures reliable PHP to Python conversion.