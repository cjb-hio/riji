package com.example.rijiserver.controller;

import cn.dev33.satoken.stp.StpUtil;
import com.example.rijiserver.dto.AuthResponse;
import com.example.rijiserver.dto.LoginRequest;
import com.example.rijiserver.dto.RegisterRequest;
import com.example.rijiserver.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        var user = userService.register(request.getUsername(), request.getPassword(), request.getEmail());
        StpUtil.login(user.getId());
        return ResponseEntity.ok(new AuthResponse(StpUtil.getTokenValue()));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        var user = userService.login(request.getUsername(), request.getPassword());
        StpUtil.login(user.getId());
        return ResponseEntity.ok(new AuthResponse(StpUtil.getTokenValue()));
    }
}
