package com.example.smartsurveysystem.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QuestionnaireDTO {
    private String title;
    private String description;
    private List<QuestionDTO> questions;
}

