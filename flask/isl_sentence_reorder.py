import nltk
nltk.download('punkt')
nltk.download('stopwords')
nltk.download('wordnet')

import spacy
nlp = spacy.load('en_core_web_sm')


import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer


# Initialize lemmatizer and stopwords
lemmatizer = WordNetLemmatizer()
stop_words = set(stopwords.words('english'))

# Tokenize and lemmatize function
def preprocess_text(text):
    tokens = word_tokenize(text.lower())  # Tokenize text
    processed_tokens = []

    # Lemmatize each word and remove stopwords
    for token in tokens:
        if token not in stop_words and token.isalpha():
            processed_tokens.append(lemmatizer.lemmatize(token))

    return processed_tokens


# for normal sentences = subject+object+verb

def process_text_isl(text):
    """
    Processes the input text by tokenizing, removing stopwords,
    lemmatizing, and reordering based on ISL grammar rules.
    """
    # Tokenize and lemmatize
    doc = nlp(text)
    tokens = [token.lemma_ for token in doc if token.lemma_ not in stop_words]

    # Apply ISL grammar: Example SOV structure adjustment
    # Example: "I am learning sign language" -> "learning sign language I"
    if len(tokens) >= 3:  # Check if there are enough words to rearrange
        # Assume format [Subject, Verb, Object] becomes [Object, Subject, Verb]
        isl_tokens = tokens[1:] + [tokens[0]]
    else:
        isl_tokens = tokens  # For short phrases, no change

    # Return the processed list of words
    return isl_tokens





#subject+object+question words

def process_question_isl(text):
    """
    Processes question sentences by reordering based on ISL grammar rules.
    Converts [Subject-Verb-Object] to [Object-Subject-Verb] and moves
    the question word to the end (e.g., 'What is your name?' -> 'your name what').
    """
    doc = nlp(text)

    # Tokenize the input text and identify key components
    tokens = [token.text for token in doc if not token.is_punct]

    # Identify the question word (e.g., who, what, where, etc.)
    question_word = None
    if tokens[0].lower() in {"who", "what", "where", "when", "why", "how"}:
        question_word = tokens.pop(0)  # Remove the question word from the front

    # Filter auxiliary verbs
    tokens = [token for token in tokens if token.lower() not in {"is", "are", "be"}]

    # Reorder tokens to follow ISL grammar rules
    if len(tokens) >= 2:
        isl_tokens = tokens + ([question_word] if question_word else [])
    else:
        isl_tokens = tokens  # If too short, no reordering

    return isl_tokens



#subject+object+ +ve and -ve words



def process_to_isl(text):
    """
    Converts an English sentence to an ISL-compatible structure:
    - Subject + Object + Verb ("like") (+ Negation if present).
    - Handles proper dependency parsing for subject, object, and negation.
    """
    # Tokenize the sentence
    doc = nlp(text)

    subject = None
    object_ = None
    action = None
    negation = False

    for token in doc:
        if token.dep_ == "nsubj":  # Subject
            subject = token.text
        elif token.dep_ in {"dobj", "pobj"}:  # Object
            object_ = token.text
        elif token.dep_ == "neg":  # Negation
            negation = True
        elif token.pos_ == "VERB":  # Verb
            # Identify action for ISL (remove 's' for singular verbs like 'likes')
            action = token.lemma_ if token.lemma_ != "like" else None

    # Build ISL-compatible sentence as a list of tokens
    isl_tokens = []
    if subject:
        isl_tokens.append(subject)
    if object_:
        isl_tokens.append(object_)
    if action:
        isl_tokens.append(action)
    isl_tokens.append("like")
    if negation:
        isl_tokens.append("not")

    return isl_tokens


# subject+object+number
def process_subject_object_number_sentence(text):
    """
    Processes sentences with subject + object + number into ISL format:
    - For sentences like 'I have 2 brothers', convert to 'I brothers 2'.
    - For sentences like 'I have 2 apples', convert to 'I 2 apples'.
    """
    # Tokenize the sentence using spaCy
    doc = nlp(text)

    # Initialize variables to store subject, object, and number
    subject = None
    object_ = None
    number = None

    # Iterate through the tokens to extract subject, object, and number
    for token in doc:
        if token.pos_ == "PRON" or token.pos_ == "PROPN":  # Pronouns or proper nouns are subject
            if not subject:
                subject = token.text
        elif token.pos_ == "NOUN":  # Nouns are the object
            if not object_:
                object_ = token.text
        elif token.pos_ == "NUM":  # Numbers
            number = token.text

    # Handle reordering for ISL: subject + number + object
    isl_tokens = []

    if subject:
        isl_tokens.append(subject)  # Add the subject first
    if number:
        isl_tokens.append(number)  # Add the number next
    if object_:
        isl_tokens.append(object_)  # Add the object last

    return isl_tokens



#subject+object+adjective
def process_adjective_sentence(text):
    """
    Converts an English sentence with adjectives to an ISL-compatible structure:
    - Subject + Object + Adjective (+ Negation if present).
    - Returns individual tokens as a list.
    """
    # Tokenize the sentence
    doc = nlp(text)

    subject = None
    object_ = None
    adjective = None
    negation = False

    for token in doc:
        # Identifying subject and object based on dependency parsing
        if token.dep_ == "nsubj":  # Subject
            subject = token.text
        elif token.dep_ in {"dobj", "pobj"}:  # Object
            object_ = token.text
        elif token.dep_ == "neg":  # Negation
            negation = True
        elif token.pos_ == "ADJ":  # Adjective
            adjective = token.text

    # Handle the case where object is not captured from dependencies
    if not object_:
        for token in doc:
            # Sometimes the object may not be captured properly, we check for common nouns (e.g., 'boy', 'girl')
            if token.pos_ == "NOUN" and token.dep_ != "nsubj":
                object_ = token.text
                break

    # Build ISL-compatible sentence as a list of tokens
    isl_tokens = []
    if subject:
        isl_tokens.append(subject)
    if object_:
        isl_tokens.append(object_)
    if adjective:
        isl_tokens.append(adjective)
    if negation:
        isl_tokens.append("not")

    return isl_tokens


# Function to determine the logic based on sentence type
# Function to determine the logic based on sentence type
def process_input_sentence(sentence):
    doc = nlp(sentence)

    # Check for question sentences
    if "?" in sentence:
        return process_question_isl(sentence)

    # Check for sentences with positive/negative words
    if any(word in sentence.lower() for word in ["like", "dislike", "love", "hate", "not", "doesn't", "don't"]):
        return process_to_isl(sentence)

    # Check for sentences with numbers
    if any(token.pos_ == "NUM" for token in doc):
        return process_subject_object_number_sentence(sentence)

    # Check for sentences with adjectives
    if any(token.pos_ == "ADJ" for token in doc):
        return process_adjective_sentence(sentence)

    # Fallback to normal text processing for unclassified sentences
    return process_text_isl(sentence)

# Main function for interactive input
def main():
    print("Enter a sentence (type 'exit' to quit):")
    while True:
        user_input = input("Input: ").strip()
        if user_input.lower() == "exit":
            print("Exiting...")
            break
        try:
            result = process_input_sentence(user_input)
            print("Processed ISL-Compatible Tokens:", result)
        except Exception as e:
            print("Error processing the input:", str(e))
        print("-" * 50)

# Run the main function
if __name__ == "__main__":
    main()