package com.serverest.reto;

import com.intuit.karate.junit5.Karate;

class TestUsuarios {

    @Karate.Test
    Karate testUsuarios() {
        return Karate.run("usuarios/usuarios-listar")
                .relativeTo(getClass());
    }
}