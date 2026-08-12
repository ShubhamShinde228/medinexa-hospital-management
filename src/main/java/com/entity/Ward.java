package com.entity;

public class Ward {
	private int id;
    private String wardName;
    private String wardType;
    private int capacity;
    private int currentOccupancy;
    
	

	public Ward() {}

	public Ward( String wardName, String wardType, int capacity, int currentOccupancy) {
		super();
		
		this.wardName = wardName;
		this.wardType = wardType;
		this.capacity = capacity;
		this.currentOccupancy = currentOccupancy;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getWardName() {
		return wardName;
	}

	public void setWardName(String wardName) {
		this.wardName = wardName;
	}

	public String getWardType() {
		return wardType;
	}

	public void setWardType(String wardType) {
		this.wardType = wardType;
	}

	public int getCapacity() {
		return capacity;
	}

	public void setCapacity(int capacity) {
		this.capacity = capacity;
	}

	public int getCurrentOccupancy() {
		return currentOccupancy;
	}

	public void setCurrentOccupancy(int currentOccupancy) {
		this.currentOccupancy = currentOccupancy;
	}
	
	
   
	
    
}
