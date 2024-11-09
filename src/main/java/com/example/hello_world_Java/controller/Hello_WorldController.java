package com.example.hello_world_Java.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class Hello_WorldController {

    @Override
    public String toString() {
        return "Hello_WorldController []";
    }

    @GetMapping("/index")
    public String index() {
        return "index";  // Thymeleaf busca un archivo hola.html en templates
    }
}


