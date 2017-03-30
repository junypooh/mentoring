package kr.or.career.mentor.domain;

import lombok.Data;

import org.springframework.security.core.GrantedAuthority;

@Data
public class Authority implements GrantedAuthority{
	String authority;
}
