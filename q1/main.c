#include <stdio.h>

struct Node{
    int val;
    struct Node *left;
    struct Node *right;
};

struct Node *make_node(int val){
    struct Node *newnode = (struct Node*)(malloc(24));
    newnode->val = val;
    newnode->left = NULL;
    newnode->right =  NULL;
}

struct Node* insert(struct Node* root, int val){
    if(root == NULL){
        return make_node(val);
    }else{
        if(val < root->val){
            root->left = insert(root->left, val);
        }else if(val > root->val){
            root->right = insert(root->right, val);
        }
        return root;
    }
}

struct Node *get(struct Node *root, int val){
    if(root == NULL){
        return root;
    }else{
        if(val < root->val){
            return get(root->left, val);
        }else if(val > root->val){
            return get(root->right, val);
        }else{
            return root;
        }
    }
}

