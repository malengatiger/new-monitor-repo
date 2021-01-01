package com.monitor.backend.data;

import java.util.List;

/*
data class Position(var type: String, var coordinates: List<Double>) {
}
 */
public class Position {
    String type;
    List<Double> coordinates;

    public Position(String type, List<Double> coordinates) {
        this.type = type;
        this.coordinates = coordinates;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public List<Double> getCoordinates() {
        return coordinates;
    }

    public void setCoordinates(List<Double> coordinates) {
        this.coordinates = coordinates;
    }
}
