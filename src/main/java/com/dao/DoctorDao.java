package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.entity.Doctor;

public class DoctorDao {
     
	private Connection conn;

	public DoctorDao(Connection conn) {
		super();
		this.conn = conn;
	}
	
	public boolean registerDoctor(Doctor d)
	{
		boolean f=false;   
		try {
			String sql = "INSERT INTO doctor(full_name, dob, qualification, specialist,mobno, email,  password) VALUES (?, ?, ?, ?, ?, ?, ?)";

			PreparedStatement ps=conn.prepareStatement(sql);
			ps.setString(1,d.getFullName());
			ps.setString(2,d.getDob());
			ps.setString(3, d.getQualification());
			ps.setString(4,d.getSpecialist());
			ps.setString(5,d.getMobNo());
			ps.setString(6, d.getEmail());
			ps.setString(7, d.getPassword());
			
			int i=ps.executeUpdate();
			if(i==1)
			{
				
				f=true;
				
			}
			
			
		}catch(Exception e){
			e.printStackTrace();
			
		}
		return f;
	}
	

	   
	    public List<Doctor> getAllDoctors() {
	        List<Doctor> list = new ArrayList<>();
	        try {
	            String sql = "SELECT * FROM doctor";
	            PreparedStatement ps = conn.prepareStatement(sql);
	            ResultSet rs = ps.executeQuery();
	            while (rs.next()) {        
	                Doctor d = new Doctor();
	                d.setId(rs.getInt("id")); 
	                d.setFullName(rs.getString("full_name"));
	                d.setDob(rs.getString("dob"));
	                d.setQualification(rs.getString("qualification"));
	                d.setSpecification(rs.getString("specialist"));
	                d.setMobNo(rs.getString("mobno"));
	                d.setEmail(rs.getString("email"));
	                d.setPassword(rs.getString("password"));
	                list.add(d);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return list;
	    }
	    
	    
	    public Doctor getDoctorById(int id) {
	      
	    	Doctor d=null;
	        try {
	            String sql = "SELECT * FROM doctor where id=?";
	            PreparedStatement ps = conn.prepareStatement(sql);
	            ps.setInt(1, id);
	            ResultSet rs = ps.executeQuery();
	            
	            
	            while (rs.next()) {
	                 d = new Doctor();
	                d.setId(rs.getInt("id")); 
	                d.setFullName(rs.getString("full_name"));
	                d.setDob(rs.getString("dob"));
	                d.setQualification(rs.getString("qualification"));
	                d.setSpecification(rs.getString("specialist"));
	                d.setMobNo(rs.getString("mobno"));
	                d.setEmail(rs.getString("email"));
	                d.setPassword(rs.getString("password"));
	               
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return d;
	    }
	
	    public boolean deleteDoctor(int id) {
	    	
	        boolean isDeleted = false;
	        try {
	            String sql = "DELETE FROM doctor WHERE id = ?";
	            PreparedStatement ps = conn.prepareStatement(sql);
	            ps.setInt(1, id);
	            int result = ps.executeUpdate();
	            if (result == 1) {
	                isDeleted = true;
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return isDeleted;
	    }
	    
	    public boolean updateDoctor(Doctor d)
		{
			boolean f=false;
			try {
				String sql = "update doctor set full_name=?, dob=?, qualification=?, specialist=?,mobno=?, email=?,  password=? where  id=?";

				PreparedStatement ps=conn.prepareStatement(sql);
				
				ps.setString(1,d.getFullName());
				ps.setString(2,d.getDob());
				ps.setString(3, d.getQualification());
				ps.setString(4,d.getSpecialist());
				ps.setString(5,d.getMobNo());
				ps.setString(6, d.getEmail());
				ps.setString(7, d.getPassword());
				
				ps.setInt(8,d.getId());
				int i=ps.executeUpdate();
				if(i==1)
				{
					
					f=true;
					
				}
				
				
			}catch(Exception e){
				e.printStackTrace();
				
			}
			return f;
		}

	    public Doctor login(String em,String psw)
	    {
	     Doctor d=null;
	    
			try {
				String sql="select * from doctor where email=? and password=?";
				PreparedStatement ps=conn.prepareStatement(sql);
				ps.setString(1,em);
				ps.setString(2,psw);
				
				ResultSet rs=ps.executeQuery();
				while(rs.next())
				{
					  d=new Doctor();
					 d = new Doctor();
		                d.setId(rs.getInt(1)); 
		                d.setFullName(rs.getString(2));
		                d.setDob(rs.getString(3));
		                d.setQualification(rs.getString(4));
		                d.setSpecification(rs.getString(5));
		                d.setMobNo(rs.getString(6));
		                d.setEmail(rs.getString(7));
		                d.setPassword(rs.getString(8));
				}
				
				
			}
			catch(Exception e)
			{
				
				e.printStackTrace();
			}
	    return d;
	    }
	    
	    
	    public int countDoctor()
	    {
	    	
	    	int i=0;
	    	try {
	    		
	    		String sql="select * from doctor";
	    		PreparedStatement ps=conn.prepareStatement(sql);
	    		ResultSet rs=ps.executeQuery();
	    		
	    		while(rs.next())
	    		{
	    			i++;
	    		}
	    		
	    	}
	    	catch(Exception e)
	    	{
	    		e.printStackTrace();
	    		
	    	}
	    	
	    	return i;
	    
	    }
	 
	    
	    public int countAppointment()
	    {
	    	
	    	int i=0;
	    	try {
	    		
	    		String sql="select * from appointment";
	    		PreparedStatement ps=conn.prepareStatement(sql);
	    		ResultSet rs=ps.executeQuery();
	    		
	    		while(rs.next())
	    		{
	    			i++;
	    		}
	    		
	    	}
	    	catch(Exception e)
	    	{
	    		e.printStackTrace();
	    		
	    	}
	    	
	    	return i;
	    
	    }
	 
	    
	    public int countUser()
	    {
	    	
	    	int i=0;
	    	try {
	    		
	    		String sql="select * from users";
	    		PreparedStatement ps=conn.prepareStatement(sql);
	    		ResultSet rs=ps.executeQuery();
	    		
	    		while(rs.next())
	    		{
	    			i++;
	    		}
	    		
	    	}
	    	catch(Exception e)
	    	{
	    		e.printStackTrace();
	    		
	    	}
	    	
	    	return i;
	    
	    }
	    
	    
	    
	    public int countSpecialist()
	    {
	    	
	    	int i=0;
	    	try {
	    		
	    		String sql="select * from specialist";
	    		PreparedStatement ps=conn.prepareStatement(sql);
	    		ResultSet rs=ps.executeQuery();
	    		
	    		while(rs.next())
	    		{
	    			i++;
	    		}
	    		
	    	}
	    	catch(Exception e)
	    	{
	    		e.printStackTrace();
	    		
	    	}
	    	
	    	return i;
	    
	    }
	    
	    public int countAppointmentByDoctorId(int did)
	    {
	    	
	    	int i=0;
	    	try {
	    		
	    		String sql="select * from  appointment where doctor_id=?";
	    		PreparedStatement ps=conn.prepareStatement(sql);
	    		ps.setInt(1,did);
	    		ResultSet rs=ps.executeQuery();
	    		
	    		while(rs.next())
	    		{
	    			i++;
	    		}
	    		
	    	}
	    	catch(Exception e)
	    	{
	    		e.printStackTrace();
	    		
	    	}
	    	
	    	return i;
	    
	    }
	    

	    public List<Doctor> getAllDoctorsReport() {
	        List<Doctor> list = new ArrayList<>();
	        try {
	            String sql = "SELECT * FROM doctor";
	            PreparedStatement ps = conn.prepareStatement(sql);
	            ResultSet rs = ps.executeQuery();
	            while (rs.next()) {        
	                Doctor doc = new Doctor();
	                doc.setId(rs.getInt("id")); 
	                doc.setFullName(rs.getString("full_name"));
	                doc.setDob(rs.getString("dob"));
	                doc.setQualification(rs.getString("qualification"));
	                doc.setSpecification(rs.getString("specialist"));
	                doc.setQualification(rs.getString("qualification"));
	                doc.setMobNo(rs.getString("mobno"));
	                doc.setEmail(rs.getString("email"));
	                doc.setPassword(rs.getString("password"));
	                list.add(doc);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return list;
	    }
	    
	    
	    public List<Doctor> getAllDoctorsnew() {
	        List<Doctor> doctors = new ArrayList<>();
	        try {
	            String query = "SELECT * FROM doctors";
	            PreparedStatement pstmt = conn.prepareStatement(query);
	            ResultSet rs = pstmt.executeQuery();
	            while (rs.next()) {
	                Doctor doctor = new Doctor();
	                doctor.setId(rs.getInt("id"));
	                doctor.setFullName(rs.getString("name"));  
	                doctor.setSpecialist(rs.getString("specialization")); 
	                doctors.add(doctor);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return doctors;
	    }
	}
	    



