package kr.or.career.mentor.service;

import lombok.Data;


public class CommonsTest {

    @Data
     static class ClassA {
        private String name;
        private Integer age;
        private String gender;
        private String email;
    }
    @Data
     static class ClassB {
        private String name;
    }


}
