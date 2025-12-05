/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.util.Random;

/**
 *
 * @author Administrator
 */
public class RandomPassword {
    public String randomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        Random rnd = new Random();
        StringBuilder token = new StringBuilder();
        for (int i = 0; i < length; i++) {
            token.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return token.toString();
    }
}
