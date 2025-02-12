##IAM and S3 Infrastructure Setup

**Scenario:**

Company ABC has created an S3 bucket named `bucket-lab-iam-xidera-NAME`. This bucket has two main folders:

1. **`/public/`**: Contains files that certain users will be able to access with read-only permissions.  
2. **`/private/`**: Contains internal information. Only an administrator user and a backup role will have read/write access.

Additionally, an application running on **Amazon EC2** should be able to **read** files from both `/public/` and `/private/`, but should not be able to perform write or delete operations.

**Requirements:**

1. **Read-only Group and Policy:**
   - A group called `GrupoLectoresS3` will be created, including users who can only **list** and **read** objects in the `/public/` folder.  
   - These users should **not** be able to read, upload, or delete objects in the `/private/` folder.

2. **Administrator User:**
   - A user named `admin-s3` will have **full access** (read, write, and delete) to the entire bucket.  
   - This user should be able to view both the `/public/` and `/private/` folders, and perform upload and delete operations in both.

3. **IAM Role for EC2:**
   - An IAM role for the EC2 instance, named `EC2S3ReadOnlyRole`, will be created, allowing:
     - **Read** access to objects in both `/public/` and `/private/`.  
     - **List** access to the entire bucket.  
     - **No** permission to upload or delete objects.

4. **Additional Security Requirements:**
   - **Encryption at rest**: Ensure that the bucket has **encryption** enabled (SSE-S3 or SSE-KMS).
   - **Public access block**: Ensure that the bucket is not publicly accessible (using Bucket Policy or Access Block Settings).

---

### **Steps Taken:**

**1. Create or Verify Bucket and Folder Structure**

1.1. **Created the bucket** `bucket-lab-iam-xidera-NAME`.  
1.2. **Created folders** `/public/` and `/private/` inside the bucket.  
1.3. **Uploaded test files** in both folders.  
1.4. **Enabled encryption at rest** (SSE-S3) on the bucket at the S3 configuration level.

---

**2. Block Public Access and Configure Bucket Policy (Optional)**

2.1. In the S3 console, reviewed the **Block Public Access** settings and ensured that **all options** were enabled to block public access.  
2.2. Reviewed or edited the **Bucket Policy** to ensure public access and anonymous permissions were blocked.

---

**3. Create IAM Policy for S3 Read-Only Users (Public Folder)**

3.1. In the IAM console, created a policy named `LecturaS3PublicPolicy` with the following permissions:
   - **Actions**:  
     - `s3:ListBucket` for `arn:aws:s3:::bucket-lab-iam`.  
     - `s3:GetObject` for `arn:aws:s3:::bucket-lab-iam/public/*`.  
   - Denied access to `arn:aws:s3:::bucket-lab-iam/private/*`.

     ![image](https://github.com/user-attachments/assets/c1b80906-5b20-4e9c-b7e0-45266a8cc532)

3.2. Saved the policy and confirmed it appeared in the list of custom policies.

---

**4. Create IAM Group and Add Read-Only Users**

4.1. Created a group called `GrupoLectoresS3`.  
4.2. Added the `LecturaS3PublicPolicy` to the group.  
4.3. Created users (`usuario1`, `usuario2`) and added them to the `GrupoLectoresS3` group.

![image](https://github.com/user-attachments/assets/a58f7672-9482-4acc-b5c0-8e065d1dc1a0)

![image](https://github.com/user-attachments/assets/34f3d54d-9d7e-4e6b-a949-3216660d29a2)

---

**5. Create and Test Administrator User (`admin-s3`)**

5.1. Created an IAM user called `admin-s3`.  
5.2. Assigned the `AmazonS3FullAccess` custom policy allowing `s3:*` actions on `arn:aws:s3:::bucket-lab-iam/*`).  
5.3. **Verified**:
   - `admin-s3` could list and read objects in both `/public/` and `/private/`.  
   - `admin-s3` could **upload** and **delete** objects in both folders.

![image](https://github.com/user-attachments/assets/9433aabd-9184-427f-b8e0-6e2daf65cf28)

---

**6. Create IAM Role for EC2 with Read-Only Access**

6.1. In the IAM console, created a role named `EC2S3ReadOnlyRole`.  
   - **Entity type**: **AWS service → EC2**.  
6.2. Assigned a read-only policy for the bucket.
6.3. Configured the EC2 instance to assume the `EC2S3ReadOnlyRole`.

![image](https://github.com/user-attachments/assets/935f0517-6f2a-496d-a4be-776c2aef8346)

![image](https://github.com/user-attachments/assets/9fd3d88c-cc64-4777-9051-3b807b5409ea)


---

**8. Validation Tests**

1. **Users in the Read-Only Group** (`usuario1`, `usuario2`):
   - Listed the bucket. This was successful.  
   - Attempted to **download** an object from `/public/`. This was successful.  
   - Attempted to **read** an object from `/private/`. This failed due to insufficient permissions.  
   - Attempted to **upload** and/or **delete** objects in `/public/`. This failed.

     List Bucket usuario1:
     ![image](https://github.com/user-attachments/assets/a8889f51-2be2-492d-a184-10dd4b3d73dc)

     Download from public usuario1:
     ![image](https://github.com/user-attachments/assets/2bfdefe5-fb48-4f58-aa6c-f2d880d7d42c)

     Read from private usuario1:
     ![image](https://github.com/user-attachments/assets/01cdcb57-5cd8-4f6d-a81f-3c5de108b2ce)

     Upload and delete from public usuario1:
     ![image](https://github.com/user-attachments/assets/5f38258f-3db4-44e9-85ce-dec7cff5e16c)



     List Bucket usuario2:
     ![image](https://github.com/user-attachments/assets/a8889f51-2be2-492d-a184-10dd4b3d73dc)

     Download from public usuario2:
     ![image](https://github.com/user-attachments/assets/2bfdefe5-fb48-4f58-aa6c-f2d880d7d42c)

     Read from private usuario2:
     ![image](https://github.com/user-attachments/assets/75e1aa12-e337-4dde-baf5-67baaca7562b)

     Upload and delete from public usuario2:
     ![image](https://github.com/user-attachments/assets/8bc12f4e-84f8-4feb-9d06-756a48aef024)


     

2. **Administrator User** (`admin-s3`):
   - Successfully listed and read all objects.  
   - Successfully **uploaded** an object to `/private/`.  
   - Successfully **deleted** an object in `/public/`.
  
     List objects in bucket:
     ![image](https://github.com/user-attachments/assets/8cb99f70-856f-431c-bd56-e82d343d699e)

     Upload an object:
     ![image](https://github.com/user-attachments/assets/46a3a5d4-7149-48b0-a490-f7ca9364fc13)

     Delete an object:
     ![image](https://github.com/user-attachments/assets/fdc3c94a-b369-4148-8007-9f67ceac7712)



3. **EC2 Instance with `EC2S3ReadOnlyRole`**:
   - Connected to the EC2 instance (via SSH or Session Manager).  
   - Executed:
     ```bash
     aws s3 ls s3://bucket-lab-iam
     aws s3 cp s3://bucket-lab-iam/private/example.txt .
     aws s3 cp s3://bucket-lab-iam/public/another-file.txt .
     ```
   - Successfully downloaded the files.  
   - Attempted to **upload** a file (e.g., `aws s3 cp localfile.txt s3://bucket-lab-iam/private/`) and confirmed that the operation failed due to insufficient permissions.
     ![image](https://github.com/user-attachments/assets/c21ace8e-091c-49e8-acca-d7f8b72fbd41)


---

This completes the IAM and S3 exercise and ensures secure, appropriate access to resources while meeting the company's requirements.
