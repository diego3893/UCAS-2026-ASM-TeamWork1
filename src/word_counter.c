#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>

#define MAX_WORD_LEN 100   
#define MAX_WORDS 20000   

typedef struct{
    char word[MAX_WORD_LEN];
    int count;
}WordRecord;

WordRecord dictionary[MAX_WORDS];
int dict_size = 0;

void process_word(char[]);

int main(){
    const char *filename = "../test/data.in";
    FILE *file = fopen(filename, "r");

    char temp_word[MAX_WORD_LEN];
    int temp_index = 0;
    int ch;

    while((ch = fgetc(file)) != EOF){
        if(isalpha(ch)){
            if(temp_index < MAX_WORD_LEN-1){
                temp_word[temp_index++] = tolower(ch);
            }
        }else{
            if(temp_index > 0){
                temp_word[temp_index] = '\0'; 
                process_word(temp_word);      
                temp_index = 0;               
            }
        }
    }

    if(temp_index > 0){
        temp_word[temp_index] = '\0';
        process_word(temp_word);
    }

    fclose(file); 

    if(dict_size == 0){
        printf("文件中没有找到任何有效的英文字母。\n");
        return 0;
    }

    int max_index = 0;
    for(int i=1; i<dict_size; ++i){
        if(dictionary[i].count > dictionary[max_index].count){
            max_index = i;
        }
    }

    printf("----------------------------------------\n");
    printf("文本分析完成！\n");
    printf("读取到的不同单词总数: %d\n", dict_size);
    printf("出现次数最多的单词是: '%s'\n", dictionary[max_index].word);
    printf("出现次数: %d 次\n", dictionary[max_index].count);
    printf("----------------------------------------\n");

    return 0;
}

void process_word(char word[]){
    if(strlen(word) == 0){
        return;
    }

    for(int i=0; i<dict_size; ++i){
        if(strcmp(dictionary[i].word, word) == 0){
            dictionary[i].count++;
            return;
        }
    }

    if(dict_size < MAX_WORDS){
        strncpy(dictionary[dict_size].word, word, MAX_WORD_LEN - 1);
        dictionary[dict_size].word[MAX_WORD_LEN - 1] = '\0';
        dictionary[dict_size].count = 1;
        dict_size++;
    }else{
        printf("警告：字典已达到最大容量 (%d)，跳过单词 '%s'\n", MAX_WORDS, word);
    }
    return;
}