# import os
# import firebase_admin
# from firebase_admin import credentials, firestore

# # Initialize Firebase Admin SDK
# cred = credentials.Certificate("serviceAccountKey.json")
# firebase_admin.initialize_app(cred)

# db = firestore.client()

# # Path to the directory containing SiGML files
# sigml_directory = "sigml_files"

# # Collection name in Firestore
# collection_name = "sigml_files"

# # Loop through each file in the directory and upload to Firestore
# for index, filename in enumerate(os.listdir(sigml_directory)):
#     if filename.endswith(".sigml"):  # Filter for SiGML files
#         file_path = os.path.join(sigml_directory, filename)
        
#         # Read the content of the SiGML file
#         with open(file_path, 'r') as file:
#             sigml_content = file.read()

#         # Create a document in Firestore
#         doc_ref = db.collection(collection_name).document(str(index))
#         doc_ref.set({"content": sigml_content})

#         print(f"Uploaded {filename} as document {index}")

# print("Batch upload completed!")
import os
import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin SDK
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

# Path to the directory containing SiGML files
sigml_directory = "sigml_files"

# Collection name in Firestore
collection_name = "sigml_files"

# Loop through each file in the directory and upload to Firestore
for filename in os.listdir(sigml_directory):
    if filename.endswith(".sigml"):  # Filter for SiGML files
        file_path = os.path.join(sigml_directory, filename)

        # Read the content of the SiGML file
        with open(file_path, 'r') as file:
            sigml_content = file.read()

        # Extract filename without extension to use as document ID
        document_id = os.path.splitext(filename)[0]

        # Create a document in Firestore
        doc_ref = db.collection(collection_name).document(document_id)
        doc_ref.set({"content": sigml_content})

        print(f"Uploaded {filename} as document {document_id}")

print("Batch upload completed!")
