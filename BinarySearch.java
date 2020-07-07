package com.oxf612;

public class Main {
	

	public static void main(String args[]) {
		
		int[] a = {1,2,3,4,5};
       
        System.out.println( binarySearch(1,a));
	}
	
	public static int binarySearch(int input, int[] data) {
		int mid = 0;
		int size = data.length;
		int left = 0;
		int right = size-1;
		
		
		mid = (left+ right)/2;
		
		while(left < right) {
			if(input > data[mid] ) {
				left = mid+1;
			}
			else {
				right = mid;
			}
			mid = (left+ right) / 2;
			
		}
		if(data[left] == input) {
			return left;
		}
		else {
			return -1;
		}
		
	}
}

// Binary Search algorithm 
// Requires a sorted array and a input value to search, also array cannot be empty
// Worst case and average case are O(log(n))

