package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.entity.Ward;

public class WardDao {

    private Connection conn;

    public WardDao(Connection conn) {
        super();
        this.conn = conn;
    }

    public boolean registerWard(Ward w) {
        boolean f = false;
        try {
            String sql = "INSERT INTO wards(ward_name, ward_type, capacity, current_occupancy) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, w.getWardName());
            ps.setString(2, w.getWardType());
            ps.setInt(3, w.getCapacity());
            ps.setInt(4, w.getCurrentOccupancy());

            int i = ps.executeUpdate();
            if (i == 1) {
                f = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    public List<Ward> getAllWards() {
        List<Ward> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM wards ORDER BY id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Ward w = new Ward(
                    rs.getString("ward_name"),
                    rs.getString("ward_type"),
                    rs.getInt("capacity"),
                    rs.getInt("current_occupancy")
                );
                w.setId(rs.getInt("id"));
                list.add(w);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean incrementOccupancyByRoom(String roomOrWardName) {
        if (roomOrWardName == null || roomOrWardName.trim().isEmpty()) return false;
        try {
            String sql = "UPDATE wards SET current_occupancy = current_occupancy + 1 WHERE ward_name = ? AND current_occupancy < capacity";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, roomOrWardName.trim());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean decrementOccupancyByRoom(String roomOrWardName) {
        if (roomOrWardName == null || roomOrWardName.trim().isEmpty()) return false;
        try {
            String sql = "UPDATE wards SET current_occupancy = GREATEST(0, current_occupancy - 1) WHERE ward_name = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, roomOrWardName.trim());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteWard(int id) {
        try {
            String sql = "DELETE FROM wards WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
