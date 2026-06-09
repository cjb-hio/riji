package com.example.rijiserver.controller;

import com.example.rijiserver.dto.AuthResponse;
import com.example.rijiserver.dto.LoginRequest;
import com.example.rijiserver.dto.RegisterRequest;
import com.example.rijiserver.security.AuthUser;
import com.example.rijiserver.service.JwtService;
import com.example.rijiserver.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    public AuthController(UserService userService, JwtService jwtService, AuthenticationManager authenticationManager) {
        this.userService = userService;
        this.jwtService = jwtService;
        this.authenticationManager = authenticationManager;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        var user = userService.register(request.getUsername(), request.getPassword(), request.getEmail());
        String token = jwtService.generateToken(user.getId(), user.getUsername());
        return ResponseEntity.ok(new AuthResponse(token));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );

        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        String token = jwtService.generateToken(authUser.getUserId(), authUser.getUsername());
        return ResponseEntity.ok(new AuthResponse(token));
    }
}
