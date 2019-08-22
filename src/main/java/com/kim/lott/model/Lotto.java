package com.kim.lott.model;

public class Lotto {
	private int minNum;
	private int maxNum;
	private int numOfNum;
	private int numOfLotto;
	public Lotto() {
	}
	public Lotto(int minNum, int maxNum, int numOfNum, int numOfLotto) {
		this.minNum = minNum;
		this.maxNum = maxNum;
		this.numOfNum = numOfNum;
		this.numOfLotto = numOfLotto;
	}
	public int getMinNum() {
		return minNum;
	}
	public void setMinNum(int minNum) {
		this.minNum = minNum;
	}
	public int getMaxNum() {
		return maxNum;
	}
	public void setMaxNum(int maxNum) {
		this.maxNum = maxNum;
	}
	public int getNumOfNum() {
		return numOfNum;
	}
	public void setNumOfNum(int numOfNum) {
		this.numOfNum = numOfNum;
	}
	public int getNumOfLotto() {
		return numOfLotto;
	}
	public void setNumOfLotto(int numOfLotto) {
		this.numOfLotto = numOfLotto;
	}
}
