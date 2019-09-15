package com.kim.lott;

import java.util.ArrayList;
import java.util.Map;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HomeController {
	
	@GetMapping
	public String home() {
		
		return "home";
	}
	
	@PostMapping("/result")
	@ResponseBody
	public ArrayList<int[]> result(@RequestBody Map<String, Object> params) {
		int minNum = Integer.parseInt((String)params.get("minNum"));
		int maxNum = Integer.parseInt((String)params.get("maxNum"));
		int numOfNum = Integer.parseInt((String)params.get("numOfNum"));
		int numOfLotto = Integer.parseInt((String)params.get("numOfLotto"));
		
		ArrayList<int[]> result = new ArrayList<int[]>();
		for( int k = 0 ; k < numOfLotto ; k++ ) {
			// 이게 한 셋트
			int[] arrLott = new int[numOfNum];
			for( int i = 0 ; i < arrLott.length ; i++ ) {
				arrLott[i] = (int)(Math.random()*(maxNum - minNum + 1)) + minNum;
				for( int r = 0 ; r < i ; r++ ) {
					if(arrLott[i] == arrLott[r]) {
						i--;
					}
				}
			}
			// 정렬
			for( int i = 0 ; i < arrLott.length - 1 ; i++ ) {
				for( int j = i+1 ; j < arrLott.length ; j++ ) {
					if( arrLott[i] > arrLott[j] ) {
						int tmp = arrLott[i];
						arrLott[i] = arrLott[j];
						arrLott[j] = tmp;
					}
				}
			}
			result.add(arrLott);
		}
		/*
		System.out.println("ArrayList.length : " + result.size());
		for(int l = 0 ; l < result.size() ; l++) {
			System.out.println("ArrayList["+l+"] : " + result.get(l).length);
			for(int h = 0 ; h < result.get(l).length ; h++) {
			System.out.println(result.get(l)[h]);
			}
		}
		*/
		return result;
	}
	
}
