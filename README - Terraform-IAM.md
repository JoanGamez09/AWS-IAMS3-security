# README: AWS IAM Configuration with Terraform

## Overview
This Terraform script (main.tf) sets up AWS IAM policies, users, groups, and roles to manage access to AWS Lambda functions. The setup includes:

1. Read-only policy for invoking Lambda functions.
2. Policy to list available Lambda functions.
3. An IAM group with read-only access to Lambda.
4. Two users assigned to the read-only group.
5. An administrator user with full access to Lambda.
6. A role for Lambda use case with necessary policies.


## Explanation of Resources

### IAM Policies
- **LambdaReadOnlyPolicyJoan**: Grants users permission to invoke Lambda functions.
- **LambdaListFunctionsPolicyJoan**: Grants permission to list all Lambda functions.
- **LambdaFullAccessPolicyJoan**: Grants full administrative access to AWS Lambda.

### IAM Group
- **LambdaReadOnlyGroupJoan**: A group that has read-only access to Lambda.
- Users `user1joan` and `user2joan` are assigned to this group.

### IAM Users
- **user1joan** & **user2joan**: Have read-only access to Lambda functions.
- **admin-lambda-user-joan**: Has full administrative access to Lambda.

### IAM Role
- **LambdaUseCaseRoleJoan**: A role that allows Lambda services to assume a role and use necessary permissions.
- The role is attached to `LambdaReadOnlyPolicyJoan` and `LambdaListFunctionsPolicyJoan`.



## Validation Tests

### **Users in the Read-Only Group** (`user1`, `user2`):
   - Listed lambda functions. This was successful.  
   - Attempted to **delete** one lambda function. This failed.

     List lambda functions user1:
     ![list1](https://github.com/user-attachments/assets/c7bf1f54-b55d-41d8-a9d5-70f5c7d82c07)
     

     Delete lambda function user1:
     ![delete1](https://github.com/user-attachments/assets/60776411-cc9c-4fc5-8c5f-31d2d76315e3)




     List lambda functions user2:
     
     ![list1](https://github.com/user-attachments/assets/7e1a6bad-b35f-46ba-a43a-945bfce2ec87)


     Delete lambda function user2:
     ![del2](https://github.com/user-attachments/assets/5fe3e29a-085b-44df-b6bf-be9252a49dcc)




2. **Administrator User** (`admin-lambda-user-joan`):
   - Successfully listed and read all objects.    
   - Successfully **edited** an object.
     
  
     List lambda functions:
     
     ![list1](https://github.com/user-attachments/assets/e4eaef8c-5c30-4903-a667-a172d91e752f)


     Edited an object:
     
     ![admin](https://github.com/user-attachments/assets/6b3e8c4b-34d1-41be-b6cf-baab38ebb331)




## Conclusion
This Terraform configuration provides a structured IAM setup for AWS Lambda with appropriate access levels. Modify the script as needed to fit your security and organizational requirements.
